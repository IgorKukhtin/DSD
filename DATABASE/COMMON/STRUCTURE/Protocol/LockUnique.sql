-- Создание - таблицы LockUnique + связей + индексов

-------------------------------------------------------------------------------

CREATE TABLE LockUnique(
   KeyData      TVarChar  NOT NULL UNIQUE,
   UserId       Integer   NOT NULL,
   OperDate     TDateTime NOT NULL
)
WITH (
  OIDS=FALSE
);
ALTER TABLE LockUnique
  OWNER TO postgres;

-------------------------------------------------------------------------------

-- Индексы
CREATE INDEX idx_LockUnique_KeyData   ON LockUnique (KeyData);
CREATE INDEX idx_LockUnique_OperDate  ON LockUnique (OperDate);

-- !!! CLUSTER !!!
CLUSTER idx_LockUnique_KeyData ON LockUnique;

/*-------------------------------------------------------------------------------*/
/*
 ПРИМЕЧАНИЯ:
 ИСТОРИЯ РАЗРАБОТКИ:
 ДАТА         АВТОР
 ----------------
                 Климентьев К.И.   Кухтин И.В.   
 12.05.17             *                                          
*/
