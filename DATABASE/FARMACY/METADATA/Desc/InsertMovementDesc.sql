insert into MovementDesc(Id, Code, ItemName)
SELECT zc_Movement_Income(), 'Income', 'Приходная накладная' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Id = zc_Movement_Income());

insert into MovementDesc(Id, Code, ItemName)
SELECT zc_Movement_ProductionUnion(), 'ProductionUnion', 'Накладная перемещения' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Id = zc_Movement_ProductionUnion());

