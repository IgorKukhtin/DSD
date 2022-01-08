/*
  Создание 
    - таблицы ContainerLinkObjectDesc ()
    - связей
    - индексов
*/

/*-------------------------------------------------------------------------------*/

-- Table: ContainerLinkObjectDesc

-- DROP TABLE ContainerLinkObjectDesc;

CREATE TABLE ContainerLinkObjectDesc
(
   Id                    SERIAL NOT NULL PRIMARY KEY, 
   Code                  TVarChar NOT NULL UNIQUE,
   ItemName              TVarChar,
   ObjectDescId          Integer,

   CONSTRAINT fk_ContainerLinkObjectDesc_ObjectDescId FOREIGN KEY(ObjectDescId) REFERENCES ObjectDesc(Id)

)
WITH (
  OIDS=FALSE
);
ALTER TABLE ContainerLinkObjectDesc
  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*                                  Индексы                                      */



/*-------------------------------------------------------------------------------
 ПРИМЕЧАНИЯ:
 ИСТОРИЯ РАЗРАБОТКИ:
 ДАТА         АВТОР
 ----------------
                 Климентьев К.И.   Кухтин И.В.   
 29.06.13             * SERIAL
*/
