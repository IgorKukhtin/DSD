--------------------------- !!!!!!!!!!!!!!!!!!!
--------------------------- !!! НОВАЯ СХЕМА !!!
--------------------------- !!!!!!!!!!!!!!!!!!!
CREATE OR REPLACE FUNCTION zc_MovementItemContainer_Count() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemContainerDesc WHERE Code = 'zc_MovementItemContainer_Count'); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_MovementItemContainer_Summ() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemContainerDesc WHERE Code = 'zc_MovementItemContainer_Summ'); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.

 07.07.13         * НОВАЯ СХЕМА
*/

