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
  id integer NOT NULL,
  code tvarchar,
  itemname tvarchar,
  CONSTRAINT ContainerLinkObjectDesc_PKey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE ContainerLinkObjectDesc
  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*                                  Индексы                                      */

/*
 ПРИМЕЧАНИЯ:
 ИСТОРИЯ РАЗРАБОТКИ:
 ДАТА         АВТОР
 ----------------
                 Климентьев К.И.   Кухтин И.В.   
18.06.02                                         
11.07.02                                         
*/