/*
  Создание 
    - таблицы PlanMobileApp (Предсозданое выполнение плана по приложению)
    - связей
    - индексов
*/


-- DROP TABLE ImplementationPlan;

/*-------------------------------------------------------------------------------*/
CREATE TABLE ImplementationPlan
(
  UserId           Integer,
  UnitId           Integer,  
  PenaltiMobApp    TFloat,
  AntiTOPMP_Place  Integer,
  
  Total            TFloat,

  CONSTRAINT pk_ImplementationPlan PRIMARY KEY (UserId)
);

ALTER TABLE ImplementationPlan
  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/


/*
 ПРИМЕЧАНИЯ:
 ИСТОРИЯ РАЗРАБОТКИ:
 ДАТА         АВТОР
 ----------------
                 Климентьев К.И.   Кухтин И.В.   Фелонюк И.В.   Шаблий О.В.
22.06.2023                                                        *
*/