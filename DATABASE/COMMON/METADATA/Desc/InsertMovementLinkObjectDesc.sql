insert into MovementLinkObjectDesc(Id, Code, ItemName)
SELECT zc_MovementLink_To(), 'To', 'Сущность на которую идет приход товара' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Id = zc_MovementLink_To());

insert into MovementLinkObjectDesc(Id, Code, ItemName)
SELECT zc_MovementLink_From(), 'From', 'Сущность c которой идет приход товара' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Id = zc_MovementLink_From());

insert into MovementLinkObjectDesc(Id, Code, ItemName)
SELECT zc_MovementLink_DocumentKind(), 'DocumentKind', 'Вид хозяйственной операции' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Id = zc_MovementLink_DocumentKind());

insert into MovementLinkObjectDesc(Id, Code, ItemName)
SELECT zc_MovementLink_PaidKind(), 'PaidKind', 'Виды форм оплаты' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Id = zc_MovementLink_PaidKind());

insert into MovementLinkObjectDesc(Id, Code, ItemName)
SELECT zc_MovementLink_Contract(), 'Contract', 'Договор' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Id = zc_MovementLink_Contract());

insert into MovementLinkObjectDesc(Id, Code, ItemName)
SELECT zc_MovementLink_Car(), 'Car', 'Автомобиль' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Id = zc_MovementLink_Car());

insert into MovementLinkObjectDesc(Id, Code, ItemName)
SELECT zc_MovementLink_PersonalDriver(), 'PersonalDriver', 'Сотрудник (водитель)' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Id = zc_MovementLink_PersonalDriver());

insert into MovementLinkObjectDesc(Id, Code, ItemName)
SELECT zc_MovementLink_PersonalPacker(), 'PersonalPacker', 'Сотрудник (заготовитель)' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Id = zc_MovementLink_PersonalPacker());
