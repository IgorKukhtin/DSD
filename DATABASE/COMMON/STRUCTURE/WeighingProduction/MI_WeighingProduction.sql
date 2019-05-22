/*
  Создание 
    - таблицы MI_WeighingProduction (oбъекты)
    - связей
    - индексов
*/
--drop TABLE MI_WeighingProduction

/*-------------------------------------------------------------------------------*/

CREATE TABLE MI_WeighingProduction(
   Id                  Integer  NOT NULL PRIMARY KEY, 
   MovementId          Integer  NOT NULL,
   ParentId            Integer ,
   GoodsTypeKindId     Integer ,
   BarCodeBoxId        Integer ,
   WmsCode             TVarChar,
   LineCode            Integer ,
   DateInsert          TDateTime,
   DateUpdate          TDateTime,
   IsErased            Boolean
   );
/*-------------------------------------------------------------------------------*/

/*                                  Индексы                                      */

--CREATE INDEX idx_MI_WeighingProduction_Id	 ON MI_WeighingProduction (Id);
--CREATE INDEX idx_MI_WeighingProduction_OperDate ON MI_WeighingProduction (OperDate);
--CREATE INDEX idx_MI_WeighingProduction_MovementId  ON MI_WeighingProduction (MovementId);

/*-------------------------------------------------------------------------------*/
/*
 ПРИМЕЧАНИЯ:
 ИСТОРИЯ РАЗРАБОТКИ:
 ДАТА         АВТОР
 ----------------
                 Климентьев К.И.   Кухтин И.В.   Фелонюк И.В.    
22.05.19                                            *
*/




