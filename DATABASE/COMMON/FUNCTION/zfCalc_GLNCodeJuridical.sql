-- Function: zfCalc_GLNCodeJuridical

DROP FUNCTION IF EXISTS zfCalc_GLNCodeJuridical (TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION zfCalc_GLNCodeJuridical(
    IN inGLNCode                  TVarChar, -- 
    IN inGLNCodeJuridical_partner TVarChar, -- 
    IN inGLNCodeJuridical         TVarChar  -- 
)
RETURNS TVarChar AS
$BODY$
BEGIN
     -- ���������� ���������
     RETURN (CASE WHEN inGLNCodeJuridical_partner <> ''
                       THEN inGLNCodeJuridical_partner
                  WHEN inGLNCode <> ''
                       THEN inGLNCodeJuridical
                  ELSE ''
             END);

END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;
ALTER FUNCTION zfCalc_GLNCodeJuridical (TVarChar, TVarChar, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 19.03.15                                        *
*/
/*
-- ����
SELECT * FROM zfCalc_GLNCodeJuridical (inGLNCode                  := '1'
                                     , inGLNCodeJuridical_partner := '2'
                                     , inGLNCodeJuridical         := '3'
                                      )
*/