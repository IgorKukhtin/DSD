-- Function: zfCalc_GLNCodeCorporate

DROP FUNCTION IF EXISTS zfCalc_GLNCodeCorporate (TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION zfCalc_GLNCodeCorporate(
    IN inGLNCode                  TVarChar, -- 
    IN inGLNCodeCorporate_partner TVarChar, -- 
    IN inGLNCodeCorporate_retail  TVarChar, -- 
    IN inGLNCodeCorporate_main    TVarChar  -- 
)
RETURNS TVarChar AS
$BODY$
BEGIN
     -- ���������� ���������
     RETURN (CASE WHEN inGLNCodeCorporate_partner <> ''
                       THEN inGLNCodeCorporate_partner
                  WHEN inGLNCodeCorporate_retail <> '' AND inGLNCode <> ''
                       THEN inGLNCodeCorporate_retail
                  WHEN inGLNCode <> ''
                       THEN inGLNCodeCorporate_main
                  ELSE ''
             END);

END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;
ALTER FUNCTION zfCalc_GLNCodeCorporate (TVarChar, TVarChar, TVarChar, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 19.03.15                                        *
*/
/*
-- ����
SELECT * FROM zfCalc_GLNCodeCorporate (inGLNCode                  := '1'
                                     , inGLNCodeCorporate_partner := '2'
                                     , inGLNCodeCorporate_retail  := '3'
                                     , inGLNCodeCorporate_main    := '4'
                                      )
*/