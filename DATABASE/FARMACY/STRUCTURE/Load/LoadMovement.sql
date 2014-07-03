/*
  Создание 
    - таблицы LoadMovement (промежуточная таблица загрузки)
    - связей
    - индексов
*/

-- Table: Movement

-- DROP TABLE LoadMovement;

/*-------------------------------------------------------------------------------*/
CREATE TABLE LoadMovement
(
  Id            serial    NOT NULL PRIMARY KEY,
  InvNumber	TVarChar, -- Номер документа
  OperDate	TDateTime, -- Дата документа
  TotalCount	TFloat  , -- Итого количество
  TotalSumm	TFloat  , -- Итого сумма
  JuridicalId	Integer , -- Юридические лица
  UnitId        Integer , -- Подразделения
  NDSKindId	Integer ,  -- Типы НДС
  CONSTRAINT fk_LoadMovement_JuridicalId FOREIGN KEY (JuridicalId)    REFERENCES Object (id),
  CONSTRAINT fk_LoadMovement_UnitId      FOREIGN KEY (UnitId)         REFERENCES Object (id),
  CONSTRAINT fk_LoadMovement_NDSKindId   FOREIGN KEY (NDSKindId)      REFERENCES Object (id)
)
WITH (
  OIDS=FALSE
);

ALTER TABLE LoadMovement
  OWNER TO postgres;
 
CREATE INDEX idx_LoadMovement_OperDate    ON LoadMovement(OperDate);
CREATE INDEX idx_LoadMovement_JuridicalId ON LoadMovement(JuridicalId); 
CREATE INDEX idx_LoadMovement_UnitId      ON LoadMovement(UnitId); -- констрейнт
CREATE INDEX idx_LoadMovement_NDSKindId   ON LoadMovement(NDSKindId);


/*-------------------------------------------------------------------------------*/



/*
 ПРИМЕЧАНИЯ:
 ИСТОРИЯ РАЗРАБОТКИ:
 ДАТА         АВТОР
 ----------------
                 Климентьев К.И.   Кухтин И.В.   
*/
