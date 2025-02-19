
-- Function: gpUpdate_MI_WeighingProduction_BoxCalc()

DROP FUNCTION IF EXISTS gpUpdate_MI_WeighingProduction_BoxCalc (Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_WeighingProduction_BoxCalc(
    IN inId                  Integer   , -- ���� ������� <��������>  
    IN inCountTare1          TFloat    , -- ����������
    IN inCountTare2          TFloat    , -- ����������
    IN inCountTare3          TFloat    , -- ����������
    IN inCountTare4          TFloat    , -- ����������
    IN inCountTare5          TFloat    , -- ����������
    IN inCountTare6          TFloat    , -- ����������
    IN inCountTare7          TFloat    , -- ����������
    IN inCountTare8          TFloat    , -- ����������
    IN inCountTare9          TFloat    , -- ����������
    IN inCountTare10         TFloat    , -- ����������
    IN inBoxWeight1          TFloat    , -- ���
    IN inBoxWeight2          TFloat    , -- ���
    IN inBoxWeight3          TFloat    , -- ���
    IN inBoxWeight4          TFloat    , -- ���
    IN inBoxWeight5          TFloat    , -- ���
    IN inBoxWeight6          TFloat    , -- ���
    IN inBoxWeight7          TFloat    , -- ���
    IN inBoxWeight8          TFloat    , -- ���
    IN inBoxWeight9          TFloat    , -- ���
    IN inBoxWeight10         TFloat    , -- ���
    IN inRealWeight          TFloat    , -- 
   OUT outNettoWeight        TFloat    ,
   OUT outBoxWeightTotal     TFloat    ,
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId         Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_OrderClient());
     vbUserId := lpGetUserBySession (inSession);
 
     outBoxWeightTotal := (COALESCE (inCountTare1,0) * inBoxWeight1
                         + COALESCE (inCountTare2,0) * inBoxWeight2
                         + COALESCE (inCountTare3,0) * inBoxWeight3
                         + COALESCE (inCountTare4,0) * inBoxWeight4
                         + COALESCE (inCountTare5,0) * inBoxWeight5
                         + COALESCE (inCountTare6,0) * inBoxWeight6
                         + COALESCE (inCountTare7,0) * inBoxWeight7
                         + COALESCE (inCountTare8,0) * inBoxWeight8
                         + COALESCE (inCountTare9,0) * inBoxWeight9
                         + COALESCE (inCountTare10,0) * inBoxWeight10) ::TFloat;
            
     outNettoWeight := (COALESCE (inRealWeight,0) - COALESCE (outBoxWeightTotal,0)) ::TFloat;
END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 19.02.25         *
*/

-- ����
--