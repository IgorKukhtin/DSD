-- Function: lpComplete_Movement_Invoice_CreateTemp ()

DROP FUNCTION IF EXISTS lpComplete_Movement_Invoice_CreateTemp ();

CREATE OR REPLACE FUNCTION lpComplete_Movement_Invoice_CreateTemp()
RETURNS VOID
AS
$BODY$
BEGIN
     -- таблица - Проводки
     PERFORM lpComplete_Movement_All_CreateTemp();


END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 18.07.16         *
*/

-- тест
-- SELECT * FROM lpComplete_Movement_Invoice_CreateTemp ()
