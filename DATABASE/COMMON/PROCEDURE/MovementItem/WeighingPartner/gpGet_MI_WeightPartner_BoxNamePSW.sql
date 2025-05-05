-- Function: gpGet_MI_WeightPartner_BoxNamePSW()

DROP FUNCTION IF EXISTS gpGet_MI_WeightPartner_BoxNamePSW (Integer, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_MI_WeightPartner_BoxNamePSW(
    IN inId            Integer ,      --�� ������
    IN inCountTare1    TFloat,
    IN inCountTare2    TFloat,
    IN inSession       TVarChar       -- ������ ������������
)
RETURNS TABLE (BoxName TVarChar, Password TVarChar) AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

    vbUserId:= lpGetUserBySession (inSession);


    IF inCountTare1 > 0
    THEN
        -- ������� ������-1
        RETURN QUERY
          SELECT Object.ValueData ::TVarChar
               , NULL ::TVarChar AS Password
          FROM ObjectFloat AS ObjectFloat_NPP
               INNER JOIN Object ON Object.Id = ObjectFloat_NPP.ObjectId
                                AND Object.DescId = zc_Object_Box()
          WHERE ObjectFloat_NPP.DescId = zc_ObjectFloat_Box_NPP()
            AND ObjectFloat_NPP.ValueData = 1
           ;
    ELSEIF inCountTare2 > 0
    THEN
        -- ������� ������-2
        RETURN QUERY
          SELECT Object.ValueData ::TVarChar
               , NULL ::TVarChar AS Password
          FROM ObjectFloat AS ObjectFloat_NPP
               INNER JOIN Object ON Object.Id = ObjectFloat_NPP.ObjectId
                                AND Object.DescId = zc_Object_Box()
          WHERE ObjectFloat_NPP.DescId = zc_ObjectFloat_Box_NPP()
            AND ObjectFloat_NPP.ValueData = 2
          ;
    ELSE
       RETURN QUERY
          SELECT NULL ::TVarChar AS BoxName
               , NULL ::TVarChar AS Password
          ;
    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 04.03.25         *
*/

-- ����
-- SELECT * FROM gpGet_MI_WeightPartner_BoxNamePSW(0,1,0, '183242')
