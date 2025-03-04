-- Function: gpGet_MI_WeightPartner_CheckPSW()

DROP FUNCTION IF EXISTS gpGet_MI_WeightPartner_CheckingPSW (TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpGet_MI_WeightPartner_CheckPSW (Integer, TFloat, TFloat, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_MI_WeightPartner_CheckPSW(
    IN inId            Integer ,      --�� ������
    IN inCountTare1    TFloat,
    IN inCountTare2    TFloat,
    IN inPassword      TVarChar,       -- ������������� 
    IN inSession       TVarChar       -- ������ ������������
)
RETURNS TABLE (isEdit Boolean, CountTare1 TFloat, CountTare2 TFloat) AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

    vbUserId:= lpGetUserBySession (inSession);
    
    IF COALESCE (inPassword,'') <> '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'
    THEN
        RETURN QUERY 
          SELECT FALSE AS isEdit
               , (SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.DescId = zc_MIFloat_CountTare1() AND MIF.MovementItemId = inId) ::TFloat AS CountTare1
               , (SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.DescId = zc_MIFloat_CountTare2() AND MIF.MovementItemId = inId) ::TFloat AS CountTare2
          ;                                                     
    ELSE
      RETURN QUERY 
        SELECT TRUE AS isEdit
              , inCountTare1 ::TFloat AS CountTare1
              , inCountTare2 ::TFloat AS CountTare2
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
-- SELECT * FROM gpGet_MI_WeightPartner_CheckPSW(0,1,0,'555', '183242')
