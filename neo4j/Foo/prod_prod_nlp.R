#SELECT  distinct *  from 
#(SELECT  1000000*(CASE des_Area WHEN 'Muebles' THEN 2  WHEN 'Ropa' THEN 1 ELSE 3 END) + 100000 * #idu_DepartamentoCodigo+1000 *idu_ClaseCodigo + idu_FamiliaCodigo as id_prodclase, 
 # --des_Departamento as Departamento , des_Clase as Clase, des_Familia as Familia, des_Categoria as Categoria, des_Subcategoria as Subcategoria,  
 # idu_ArticuloCodigo, des_Articulo
#  FROM `rmf2gcp.Desarrollo.productos_descripcion_cruda`) as a
#order by id_prodclase 
##################################
##librerias
library(tm)
library(xtable)
library(caret)
library(e1071)
data <- read.csv(file='pord_prod.csv')
# funciones

M.td <- function(direccion)
{
  #Obtencion de los conteos de palabras
  # direccion (string): con la ruta donde se encuentran los archivos
  # la forma facil es con esta implementacion 1
  # la otra es hacerlo a mano como lo hice en la tarea2
  corpus <- Corpus(DirSource(direccion, recursive=FALSE,
                             encoding = "UTF-8"),
                   readerControl=list(language="es"))
  #preprocesamiento
  corpus <- tm_map(corpus, stripWhitespace)
  corpus <- tm_map(corpus,removeNumbers)
  corpus <- tm_map(corpus,content_transformer(tolower))
  corpus <- tm_map(corpus,removePunctuation)
  corpus <- tm_map(corpus,content_transformer(gsub),
                   pattern="([(a-zA-Z0-9)])\\.([a-zA-Z0-9])",
                   replacement="\\1. \\2")
  corpus <- tm_map(corpus,content_transformer(gsub),
                   pattern="([(a-zA-Z0-9)])\\.([a-zA-Z0-9])",
                   replacement="\\1, \\2")
  corpus <- tm_map(corpus,content_transformer(gsub),
                   pattern="\\S+@\\S+",replacement="")
  corpus <- tm_map(corpus,removeWords,stopwords("spanish"))
  
  tdm <- TermDocumentMatrix(corpus, control=list(minDocFreq=10))
  tdm <- removeSparseTerms(tdm, 0.95)
  ## frecuencia de terminos
  term.freq <- rowSums(as.matrix(tdm))
  sort.freq <- sort.int(term.freq, decreasing=TRUE,
                        index.return=FALSE)
  return(list( term.freq.sort=sort.freq,
               tdm=tdm,
               terms=names(sort.freq),
               nterms=length(terms),
               ndocs=length(corpus)))
}
inf.M.td <- function(direccion)
{
  
  #Obtencion de los conteos de palabras con la matriz con frecuencia inversa
  # direccion (string): con la ruta donde se encuentran los archivos
  # la forma facil es con esta implementacion
  # la otra es hacerlo a mano como lo hice en la tarea2
  corpus <- Corpus(DirSource(direccion, recursive=TRUE,
                             encoding = "UTF-8"),
                   readerControl=list(language="es"))
  #preprocesamiento
  corpus <- tm_map(corpus, stripWhitespace)
  corpus <- tm_map(corpus,removeNumbers)
  corpus <- tm_map(corpus,content_transformer(tolower))
  corpus <- tm_map(corpus,removePunctuation)
  corpus <- tm_map(corpus,content_transformer(gsub),
                   pattern="([(a-zA-Z0-9)])\\.([a-zA-Z0-9])",
                   replacement="\\1. \\2")
  corpus <- tm_map(corpus,content_transformer(gsub),
                   pattern="([(a-zA-Z0-9)])\\.([a-zA-Z0-9])",
                   replacement="\\1, \\2")
  corpus <- tm_map(corpus,content_transformer(gsub),
                   pattern="\\S+@\\S+",replacement="")
  corpus <- tm_map(corpus,removeWords,stopwords("spanish"))
  tdm <- DocumentTermMatrix(corpus,
                            control=list(minDocFreq=10,
                                         weighting = function(x) weightTfIdf(x, normalize = T)))
  tdm <- removeSparseTerms(tdm, 0.95)
  ## frecuencia de terminos
  term.freq <- colSums(as.matrix(tdm))
  sort.freq <- sort.int(term.freq, decreasing=TRUE,
                        index.return=FALSE)
  return(list( term.freq.sort=sort.freq,
               tdm=tdm,
               terms=names(sort.freq),
               nterms=length(terms),
               ndocs=length(corpus)))
}
#
# como siempre hay palabras que rompen nuestra implementacion
# usamos correcion de laplace para los conteos

conteo.terminos <- function(tdm, terminos, correcion=TRUE)
{
  #Entradas
  # tdm (matriz de terminos codumentos )
  # terminos (vector) : de las palabras de la tdm
  tabla.frecuencias <- unlist(lapply(terminos, FUN= function(x){
    sum(tm_term_score(tdm,x))
  }))
  if(correcion)
    tabla.frecuencias <- tabla.frecuencias + 1
  tabla.frecuencias <- data.frame(tabla.frecuencias)
  rownames(tabla.frecuencias) <- terminos
  return(tabla.frecuencias)
}
# Encoding 1 es negativo (N), 2 es positivo (P)
Bayes.text <- function(tdm,loglik1,loglik2, logp1, logp2, terms.v){
  ## para todos los documentos de prueba
  c <- rep(0,ncol(tdm))
  for(i in 1:ncol(tdm))
  {
    ## logverosimilitudes de terminos en el vocabulario
    t.i <- rownames(tdm)[tdm[,i]>0]
    aa <- lapply(t.i, function(x) which(x==rownames(loglik1)))
    sum.loglik1 <- sum(loglik1[unlist(aa),])
    aa <- lapply(t.i,function(x) which(x==rownames(loglik2)))
    sum.loglik2 <- sum(loglik2[unlist(aa),])
    p1 <- logp1 + sum.loglik1
    p2 <- logp2 + sum.loglik2
    temp <- c(p1,p2)
    c[i] <- which(temp==max(temp))
  }
  temp <- c("N","P") #encoding
  return(temp[c])
}
###############################
path <- "C:/Users/usuario/Desktop/GitHub/RMF2Coppel/neo4j/Foo/"
setwd(path)
dir()
?M.td
##################
# Ejercicio 1
###################
# Obtencion de las frecuencias de las palabras en los dorpus positivo,negativo y general
# del train
Train.neg <- M.td(direccion ="pord_prod.csv" )
dim(Train.neg$tdm)
Train.pos <- M.td("train/yes/")
dim(Train.pos$tdm)
Train <- M.td(dir()[2])
dim(Train$tdm)
# calculo de verosimilitudes
conteo.1 <- conteo.terminos(Train.neg$tdm, Train$terms)
log.lik.1 <- log(conteo.1/sum(conteo.1))
conteo.2 <- conteo.terminos(Train.pos$tdm, Train$terms)
log.lik.2 <- log(conteo.2/sum(conteo.2))

# calculo de aprioris
## aprioris
log.neg.1 <- log(Train.neg$ndocs/Train$ndocs)
log.pos.2 <- log(Train.pos$ndocs/Train$ndocs )
###############################
## error entrenamiento
tdm.train <- as.matrix(Train$tdm) # por eso debemos cuidar que sean densas
dim(tdm.train) #se puede poner serio
Bayes.naive <- Bayes.text(tdm.train, log.lik.1, log.lik.2,
                          log.neg.1,log.pos.2, Train$terms)
## erroe de entrenamiento
clas.original <- c( rep("N",160), rep("P",160))
a <- table(clas.original, Bayes.naive)
a
xtable(a)
train.acc <- sum(diag(a))/sum(a)
train.acc
# error de prueba
Test <- M.td(dir()[1])
clas.original <- c(rep("N",40),rep("P",40))
tdm.test <- as.matrix(Test$tdm) # por eso debemos cuidar que sean densas
dim(tdm.test)
test.hat <- Bayes.text(tdm.test, log.lik.1, log.lik.2,
                       log.neg.1, log.pos.2, tdm.train$terms)
b <- table(clas.original, test.hat)
xtable(b)
test.acc <- sum(diag(b))/sum(b)
test.acc




###########################
# ejercicio 2
##########################
# Identificar las variables
tf.Idf <- inf.M.td(path)
dim(as.matrix(tf.Idf$tdm))
row.names(tf.Idf$tdm)
M.TFIDF <- as.matrix(tf.Idf$tdm)
df.TFIDF <- data.frame(M.TFIDF,
                       y=c(rep("N",40),rep("P",40),
                           rep("N",160),rep("P",160))) # por el orden de los archivos

tf.Idf$ndocs #todo bien
test.invertido <-  df.TFIDF[1:80,]
y.test <- test.invertido$y
n <- ncol(df.TFIDF)
test.invertido <- scale(test.invertido[,-n])
test <- data.frame(test.invertido,y=y.test)
tail(colnames(test))
class(test)
train.invertido <- df.TFIDF[81:400,]  #por el orden en que leyo los archivos este es el conjunto de entrenamiento
y <- train.invertido$y
train.invertido <- scale(train.invertido[,-n])
train <- data.frame(train.invertido,y=y)
tail(colnames(train))
class(train)
################################
# SVM
# tuneo de SVM con cv
set.seed(0)
tuned <- tune(svm, y~ .,  data =train,ranges = list(gamma = 2**seq(-2,10, length=2),
                                                    cost = 2**seq(-10,5,5)))
tuned
a <- tuned$best.parameters
tuned$best.performance
tuned$best.model
svm <- svm(y ~ ., data=train,
           gamma=a[1], cost=a[2])
y.hat <- predict(svm, test)
tabla <- table(test$y, y.hat )
tabla
xtable(tabla)
sum(diag(tabla))/sum(tabla)
#


tuned <- tune.knn(y=train$y , x=train[, -n],
                  k = 5*(1:20), l= 1:2,
                  tunecontrol = tune.control(sampling = "cross",
                                             cross = 100))
tuned
a <- tuned$best.parameters
tuned$best.performance
knn <- knn3(x=train[,-n], y=train$y, k=a[1], l=a[2])
y.hat <- predict(knn, test[, -n], type='class')
tabla <- table(test$y, y.hat )
sum(diag(tabla))/sum(tabla)
#
#


arbol <- tune.rpart(y~., data = train, minsplit = seq(10,30,5),
                    maxdepth=seq(2,30,5),
                    tunecontrol = tune.control(sampling = "cross",cross=60))
arbol
a <- arbol$best.parameters
arbol <- rpart::rpart(y~., train, control =list(minsplit=a[1], maxdepth=a[2]) )
y.hat <- predict(arbol, test, type='class')
tabla <- table(test$y, y.hat )
sum(diag(tabla))/sum(tabla)
############################
# ejercicio c
#################
library(wordVectors)
dir()
Todos <- M.td('~\\Desktop\\Third\\CD2\\Tarea3CD2Antonio\\spanish_reviews\\SFU_spanish_reviews_train_test\\')
head(Todos$term.freq.sort)
dim(Todos$tdm)
path <- '~\\Desktop\\Third\\CD2\\Tarea3CD2Antonio\\spanish_reviews\\'
setwd(path)

if (!file.exists("ejercicio1.txt")) prep_word2vec(origin="SFU_spanish_reviews_train_test/",
                                                  destination="ejercicio1.txt",
                                                  lowercase=T,bundle_ngrams=2)

model = train_word2vec("ejercicio1.txt","ejercicio1.bin",
                       vectors=30,
                       threads=7,
                       window=15,
                       iter=20,
                       negative_samples=7,
                       force = T)

#model@.Data
model <- read.vectors("ejercicio1.bin")
# sustantivos comunes en español pues los temas del corpus
model %>% closest_to("libros")%>% head(3)->a1
model %>% closest_to("telefonos")%>% head(3)->a2
model %>% closest_to("amor") %>% head(3)-> a3
model %>% closest_to("amar") %>% head(3)-> a4
model %>% closest_to("programar") %>% head(3)-> a5
model %>% closest_to("lavar") %>% head(3)-> a6
model %>% closest_to("audi") %>% head(3)-> a7
model %>% closest_to("pepsi") %>% head(3)-> a8
model %>% closest_to("excelente") %>% head(3)-> a9
model %>% closest_to("exelente") %>% head(3)-> a10
model %>% closest_to("ser") %>% head(3)-> a11
model %>% closest_to("bien") %>% head(3)-> a12
model %>% closest_to("ace") %>% head(3)-> a13
model %>% closest_to("hace") %>% head(3)-> a14
df <- cbind(a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14)
lista <- c("libros","telefonos","amor","amar","programar","lavar",
           "audi","pepsi","excelente","exelente","ser","bien",
           "ace","hace")
library(reshape2)
l <- paste0('Similaridad.con.', lista)
colnames(df)[seq(1,28, 2)] <- lista
colnames(df)[seq(2,28, 2)] <- rep('dist', 14)
xtable(df[,1:8])
xtable(df[,9:18])
xtable(df[,19:28])

dx <- t(df)
