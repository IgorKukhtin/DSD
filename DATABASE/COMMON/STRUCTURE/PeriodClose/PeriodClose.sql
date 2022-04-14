/*
  Создание 
    - таблицы PeriodClose (протокол)
    - связей
    - индексов
*/

/*-------------------------------------------------------------------------------*/
CREATE TABLE PeriodClose(
   Id                    SERIAL NOT NULL PRIMARY KEY, 
   OperDate              TDateTime,
   UserId                INTEGER,
   RoleId                INTEGER,
   UnitId                INTEGER,
   Period                Interval,
   CloseDate             TDateTime,
   Name                  TVarChar,
   Code                  INTEGER,
   DescId                INTEGER,
   DescId_excl           INTEGER,
   BranchId              INTEGER,
   PaidKindId            INTEGER,
   UserId_excl           INTEGER,
   UserByGroupId_excl    INTEGER,
   CloseDate_excl        TDateTime,
   CloseDate_store       TDateTime,

   CONSTRAINT fk_PeriodClose_UserId FOREIGN KEY(UserId) REFERENCES Object(Id),
   CONSTRAINT fk_PeriodClose_RoleId FOREIGN KEY(RoleId) REFERENCES Object(Id),
   CONSTRAINT fk_PeriodClose_UnitId FOREIGN KEY(UnitId) REFERENCES Object(Id)
);

/*-------------------------------------------------------------------------------*/

/*                                  Индексы                                      */

CREATE INDEX idx_PeriodClose_UserId_RoleId_UnitId ON PeriodClose (UserId, RoleId, UnitId);
CREATE INDEX idx_PeriodClose_UserId ON PeriodClose (UserId);
CREATE INDEX idx_PeriodClose_RoleId ON PeriodClose (RoleId);
CREATE INDEX idx_PeriodClose_UnitId ON PeriodClose (UnitId);

/*-------------------------------------------------------------------------------*/

/*
 ПРИМЕЧАНИЯ:
 ИСТОРИЯ РАЗРАБОТКИ:
 ДАТА         АВТОР
 ----------------
                 Климентьев К.И.   Кухтин И.В.   
18.06.02                                           
19.09.02                                                       
*/