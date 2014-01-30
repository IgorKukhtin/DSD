/*
  Создание 
    - таблицы Sale1C (промежуточная таблица продажа)
    - связей
    - индексов
*/

-- Table: Movement

-- DROP TABLE Sale1C;

/*-------------------------------------------------------------------------------*/
CREATE TABLE Sale1C
(
  Id                     serial    NOT NULL PRIMARY KEY,
  UnitId                 Integer ,
  VidDoc                 TVarChar ,
  InvNumber              TVarChar ,
  OperDate               TDateTime ,
  ClientCode             Integer ,   
  ClientName             TVarChar ,   
  GoodsCode              Integer ,   
  GoodsName              TVarChar ,   
  OperCount              TFloat ,
  OperPrice              TFloat ,
  Tax                    TFloat ,
  Doc1Date               TDateTime ,
  Doc1Number             TVarChar ,
  Doc2Date               TDateTime ,
  Doc2Number             TVarChar ,
  Suma                   TFloat ,
  PDV                    TFloat ,
  SumaPDV                TFloat ,
  ClientINN              TVarChar ,
  ClientOKPO             TVarChar ,
  InvNalog               TVarChar ,
  BillId                 Integer ,
  EkspCode               Integer ,
  ExpName                TVarChar 
)
WITH (
  OIDS=FALSE
);

ALTER TABLE Sale1C
  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/



/*
 ПРИМЕЧАНИЯ:
 ИСТОРИЯ РАЗРАБОТКИ:
 ДАТА         АВТОР
 ----------------
                 Климентьев К.И.   Кухтин И.В.   
*/
