-- Function: gpInsertUpdate_Movement_OrderClient()

DROP FUNCTION IF EXISTS gpUpdate_Movement_OrderClient_NPP (Integer, Integer, TDateTime, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_OrderClient_NPP(
    IN inId                  Integer   , -- ���� ������� <��������>
    IN inProductId           Integer   , -- �����
    IN inDateBegin           TDateTime ,
    IN inNPP                 TFloat    , -- ����������� ������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_OrderClient());
    vbUserId := lpGetUserBySession (inSession);


     -- ��������� �������� <NPP>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_NPP(), inId, inNPP);

    --�������� / ������
    /*���� ��� ����� ����� ����� ����������� ����� � ��������� ���������� �� ���������� �� +1, �.�. ���� ��������� 1,2,3;4,5 .... �������� ����� ��� � ��������� ��� �-3, ����� 3,4,5 ������������ � 4,5,6*/
     
     IF EXISTS (SELECT 1
                FROM MovementFloat
                WHERE MovementFloat.DescId = zc_MovementFloat_NPP()
                  AND COALESCE (MovementFloat.ValueData,0) = inNPP
                  AND MovementFloat.MovementId <> inId)
     THEN
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_NPP(), MovementFloat.MovementId, COALESCE (MovementFloat.ValueData,0) + 1 )
         FROM MovementFloat
             INNER JOIN Movement ON Movement.Id = MovementFloat.MovementId
                                AND Movement.DescId = zc_Movement_OrderClient()
                                AND Movement.StatusId <> zc_Enum_Status_Erased()
         WHERE MovementFloat.DescId = zc_MovementFloat_NPP()
           AND COALESCE (MovementFloat.ValueData,0) >= inNPP
           AND MovementFloat.MovementId <> inId;
     END IF; 
 
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Product_DateBegin(), inProductId, inDateBegin);     

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 08.02.23         *
*/

-- ����
--