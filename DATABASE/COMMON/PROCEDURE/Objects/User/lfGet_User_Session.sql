-- Function: lfGet_User_Session (Integer)

DROP FUNCTION IF EXISTS lfGet_User_Session (Integer);

CREATE OR REPLACE FUNCTION lfGet_User_Session(
    IN inUserId     Integer
)
RETURNS TVarChar
AS
$BODY$
BEGIN

    RETURN COALESCE ((SELECT OS.ValueData FROM ObjectString AS OS WHERE OS.ObjectId = inUserId AND OS.DescId = zc_ObjectString_User_GUID() AND OS.ValueData <> '')
                   , inUserId :: TVarChar
                    );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 02.06.21                                        *
*/
-- SELECT * FROM lfGet_User_Session (5)
