-- Function: gpGet_Object_Client_NEW_SYBASE()

DROP FUNCTION IF EXISTS gpGet_Object_Client_NEW_SYBASE (TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Client_NEW_SYBASE(
    IN inName   TVarChar
)
RETURNS TVarChar
AS
$BODY$
BEGIN

     RETURN (WITH tmp AS (select gpGet_Object_Client_NEW_SYBASE1 (inName) AS RetV
                         UNION
                          select gpGet_Object_Client_NEW_SYBASE2 (inName) AS RetV
                         UNION
                          select gpGet_Object_Client_NEW_SYBASE3 (inName) AS RetV
                         )
            SELECT RetV
            FROM tmp
            WHERE RetV <> ''
            -- LIMIT 1
            )
            ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 23.03.18                                        *
*/

-- ����
-- SELECT * FROM gpGet_Object_Client_NEW_SYBASE1 ('���� �������')
