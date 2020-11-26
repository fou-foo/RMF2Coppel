match(c:Cliente) 
WHERE c.EDO_CIVIL IS NOT NULL
with distinct(c.EDO_CIVIL) as edo
MERGE(c2:EDO_CIVIL{edocivil:edo}) return count(c2);