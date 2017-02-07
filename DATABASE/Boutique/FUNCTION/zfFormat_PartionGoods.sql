-- Function: zfFormat_PartionGoods

-- DROP FUNCTION zfFormat_PartionGoods (TVarChar);

CREATE OR REPLACE FUNCTION zfFormat_PartionGoods(
    IN inPartionGoods TVarChar
)
RETURNS TVarChar AS
$BODY$
  DECLARE vbValue TVarChar;
BEGIN
     SELECT SUBSTRING(inPartionGoods
                      FROM STRPOS (inPartionGoods, SUBSTRING (inPartionGoods, '([0-9]{1})'))
                      FOR (1 + LENGTH (inPartionGoods) - STRPOS (inPartionGoods, SUBSTRING (inPartionGoods, '([0-9]{1})'))
                          )
                     ) INTO vbValue;
     
     RETURN (vbValue);

END;
$BODY$
LANGUAGE PLPGSQL IMMUTABLE;
ALTER FUNCTION zfFormat_PartionGoods (TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 24.07.13                        *
*/

-- ����
-- SELECT * FROM zfFormat_PartionGoods ('asasa12-12-22-44')
-- SELECT * FROM zfFormat_PartionGoods ('�����72121������')