insert into MovementDateDesc(Id, Code, ItemName)
SELECT zc_MovementDate_OperDatePartner(), 'OperDatePartner', 'Дата накладной у контрагента' WHERE NOT EXISTS (SELECT * FROM MovementDateDesc WHERE Id = zc_MovementDate_OperDatePartner()); 
