CREATE OR REPLACE FUNCTION zc_MovementBoolean_PriceWithVAT() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementBooleanDesc WHERE Code = 'zc_MovementBoolean_PriceWithVAT'); END;  $BODY$ LANGUAGE plpgsql IMMUTABLE;
INSERT INTO MovementBooleanDesc (Code, ItemName)
  SELECT 'zc_MovementBoolean_PriceWithVAT', 'цена с НДС (да/нет)'  WHERE NOT EXISTS (SELECT * FROM MovementBooleanDesc WHERE Code= 'zc_MovementBoolean_PriceWithVAT');

CREATE OR REPLACE FUNCTION zc_MovementBoolean_List() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementBooleanDesc WHERE Code = 'zc_MovementBoolean_List'); END;  $BODY$ LANGUAGE plpgsql IMMUTABLE;
INSERT INTO MovementBooleanDesc (Code, ItemName)
  SELECT 'zc_MovementBoolean_List', 'Только для выбранных'  WHERE NOT EXISTS (SELECT * FROM MovementBooleanDesc WHERE Code= 'zc_MovementBoolean_List');
  
CREATE OR REPLACE FUNCTION zc_MovementBoolean_Auto() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementBooleanDesc WHERE Code = 'zc_MovementBoolean_Auto'); END;  $BODY$ LANGUAGE plpgsql IMMUTABLE;
INSERT INTO MovementBooleanDesc (Code, ItemName)
  SELECT 'zc_MovementBoolean_Auto', 'Автоматически'  WHERE NOT EXISTS (SELECT * FROM MovementBooleanDesc WHERE Code= 'zc_MovementBoolean_Auto');
  
CREATE OR REPLACE FUNCTION zc_MovementBoolean_FilesNotUploaded() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementBooleanDesc WHERE Code = 'zc_MovementBoolean_FilesNotUploaded'); END;  $BODY$ LANGUAGE plpgsql IMMUTABLE;
INSERT INTO MovementBooleanDesc (Code, ItemName)
  SELECT 'zc_MovementBoolean_FilesNotUploaded', 'Временно не выгружать файлы в DropBox'  WHERE NOT EXISTS (SELECT * FROM MovementBooleanDesc WHERE Code= 'zc_MovementBoolean_FilesNotUploaded');

CREATE OR REPLACE FUNCTION zc_MovementBoolean_PostedToDropBox() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementBooleanDesc WHERE Code = 'zc_MovementBoolean_PostedToDropBox'); END;  $BODY$ LANGUAGE plpgsql IMMUTABLE;
INSERT INTO MovementBooleanDesc (Code, ItemName)
  SELECT 'zc_MovementBoolean_PostedToDropBox', 'Отправлено в DropBox'  WHERE NOT EXISTS (SELECT * FROM MovementBooleanDesc WHERE Code= 'zc_MovementBoolean_PostedToDropBox');


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 03.03.24                                                       * zc_MovementBoolean_PostedToDropBox
 26.02.24                                                       * zc_MovementBoolean_FilesNotUploaded
 06.12.23         * zc_MovementBoolean_Auto
 10.05.22         * zc_MovementBoolean_List
 08.02.21         * zc_MovementBoolean_PriceWithVAT
 24.08.20                                        *
*/
