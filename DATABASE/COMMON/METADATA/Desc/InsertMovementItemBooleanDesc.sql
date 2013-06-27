INSERT INTO MovementItemBooleanDesc(Id, Code, ItemName)
SELECT zc_MovementItemBoolean_PartionClose(), 'PartionClose', 'Закрыта ли партия' 
       WHERE NOT EXISTS (SELECT * FROM MovementItemBooleanDesc WHERE Id = zc_MovementItemBoolean_PartionClose()); 


--------------------------- !!!!!!!!!!!!!!!!!!!
--------------------------- !!! НОВАЯ СХЕМА !!!
--------------------------- !!!!!!!!!!!!!!!!!!!
