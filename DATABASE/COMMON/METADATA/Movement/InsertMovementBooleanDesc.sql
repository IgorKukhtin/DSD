INSERT INTO MovementBooleanDesc (id, Code ,itemname)
SELECT zc_MovementBoolean_PriceWithVAT(), 'PriceWithVAT','цена с НДС (да/нет)'  WHERE NOT EXISTS (SELECT * FROM MovementBooleanDesc WHERE Id = zc_MovementBoolean_PriceWithVAT());

	
--------------------------- !!!!!!!!!!!!!!!!!!!
--------------------------- !!! НОВАЯ СХЕМА !!!
--------------------------- !!!!!!!!!!!!!!!!!!!
