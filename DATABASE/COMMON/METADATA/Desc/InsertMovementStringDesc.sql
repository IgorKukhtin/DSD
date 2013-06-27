INSERT INTO MovementStringDesc (id, Code, itemname)
SELECT zc_MovementString_InvNumberPartner(), 'InvNumberPartner', 'Номер накладной у контрагента' WHERE NOT EXISTS (SELECT * FROM MovementStringDesc WHERE Id = zc_MovementString_InvNumberPartner());
	

--------------------------- !!!!!!!!!!!!!!!!!!!
--------------------------- !!! НОВАЯ СХЕМА !!!
--------------------------- !!!!!!!!!!!!!!!!!!!
