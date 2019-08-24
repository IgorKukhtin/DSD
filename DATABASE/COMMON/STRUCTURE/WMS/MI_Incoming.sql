/*
  Создание 
    - таблицы MI_Incoming (oбъекты)
    - связей
    - индексов
*/

-- DROP TABLE MI_Incoming

/*-------------------------------------------------------------------------------*/

CREATE TABLE MI_Incoming(
   Id                  BIGSERIAL NOT NULL PRIMARY KEY, 
   MovementId          Integer   NOT NULL,
   GoodsId             Integer   NOT NULL,
   GoodsKindId	       Integer   NOT NULL,
   GoodsTypeKindId     Integer   NOT NULL,
   sku_id              TVarChar  NOT NULL, -- sku_id
   sku_code            TVarChar  NOT NULL, -- sku_code
   Amount              TFloat    NOT NULL,
   RealWeight          TFloat    NOT NULL,
   PartionDate         TDateTime NOT NULL,
   isErased            Boolean   NOT NULL
   );
/*-------------------------------------------------------------------------------*/

/*                                  Индексы                                      */

/*-------------------------------------------------------------------------------*/
/*
 ПРИМЕЧАНИЯ:
 ИСТОРИЯ РАЗРАБОТКИ:
 ДАТА         АВТОР
 ----------------
              Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 22.08.19                                       *
*/




