/*
  ALTER
    - таблица Orders
    - Создание индексов
*/


/*-------------------------------------------------------------------------------*/

ALTER TABLE Orders ADD COLUMN createDate_ch   TDateTime;
ALTER TABLE Orders ADD COLUMN dbCreateDate_ch TDateTime;
ALTER TABLE Orders ADD COLUMN OperDate_get    TDateTime;

/*-------------------------------------------------------------------------------*/

/*                                  Индексы                                      */
CREATE INDEX idx_Orders_createDate_ch ON Orders (createDate_ch);

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 10.04.26                                        *
*/
