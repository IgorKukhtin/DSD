/*
  ALTER
    - таблица order_returns
    - Создание индексов
*/


/*-------------------------------------------------------------------------------*/

ALTER TABLE order_returns ADD COLUMN createDate_ch   TDateTime;
ALTER TABLE order_returns ADD COLUMN dbCreateDate_ch TDateTime;
ALTER TABLE order_returns ADD COLUMN OperDate_get    TDateTime;

/*-------------------------------------------------------------------------------*/

/*                                  Индексы                                      */
CREATE INDEX idx_order_returns_createDate_ch ON Orders (createDate_ch);

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 10.04.26                                        *
*/
