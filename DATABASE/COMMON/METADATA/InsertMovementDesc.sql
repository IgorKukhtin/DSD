insert into MovementDesc(Id, Code, ItemName)
values (zc_Movement_Income(), 'Income', 'Приходная накладная');

insert into MovementDesc(Id, Code, ItemName)
values (zc_Movement_Transfer(), 'Transfer', 'Накладная перемещения');

insert into MovementDesc(Id, Code, ItemName)
values (zc_Movement_FoundationCash(), 'FoundationCash', 'Расчеты с учредителями');
