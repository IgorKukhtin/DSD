-- Function: gpErasedSaleFrom1C()

DROP FUNCTION IF EXISTS gpErasedSaleFrom1C (TDateTime, TDateTime, integer, TVarChar);

CREATE OR REPLACE FUNCTION gpErasedSaleFrom1C(
    IN inStartDate           TDateTime  , -- ��������� ���� ��������
    IN inEndDate             TDateTime  , -- �������� ���� ��������
    IN inBranchId            Integer    , -- ������
    IN inSession             TVarChar    -- ������ ������������
)                              
RETURNS Void AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbPaidKindId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_LoadSaleFrom1C());
     vbUserId := lpGetUserBySession (inSession);


     SELECT zfGetPaidKindFrom1CType(Sale1C.VIDDOC) INTO vbPaidKindId
     FROM Sale1C             
          WHERE Sale1C.OperDate BETWEEN inStartDate AND inEndDate
            AND zfGetBranchFromUnitId (Sale1C.UnitId) = inBranchId
     GROUP BY zfGetPaidKindFrom1CType(Sale1C.VIDDOC);

     -- !!!�������!!!

     -- �������� ���� ���������� �� ������ �� ������� 
     PERFORM gpSetErased_Movement (Movement.Id, inSession) 
     FROM Movement  
          JOIN MovementLinkObject AS MLO_From
                                  ON MLO_From.MovementId = Movement.Id
                                 AND MLO_From.DescId = zc_MovementLinkObject_From() 
          JOIN ObjectLink AS ObjectLink_Unit_Branch 
                          ON ObjectLink_Unit_Branch.ObjectId = MLO_From.ObjectId 
                         AND ObjectLink_Unit_Branch.ChildObjectId = inBranchId
                         AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
          JOIN MovementBoolean AS MovementBoolean_isLoad 
                               ON MovementBoolean_isLoad.MovementId = Movement.Id
                              AND MovementBoolean_isLoad.DescId = zc_MovementBoolean_isLoad()
                              AND MovementBoolean_isLoad.ValueData = TRUE
     LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                  ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                 AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()

     WHERE Movement.DescId = zc_Movement_Sale()
       AND Movement.OperDate BETWEEN inStartDate AND inEndDate
       AND Movement.StatusId <> zc_Enum_Status_Erased()
       AND MovementLinkObject_PaidKind.ObjectId = vbPaidKindId;
--       AND NOT ((Movement.InvNumber, Movement.OperDate) IN (SELECT DISTINCT Sale1C.InvNumber
  --                      , Sale1C.OperDate
    --       FROM Sale1C             
      --    WHERE Sale1C.OperDate BETWEEN inStartDate AND inEndDate
        --    AND ((Sale1C.VIDDOC = '1') OR (Sale1C.VIDDOC = '2')) AND inBranchId = zfGetBranchFromUnitId (Sale1C.UnitId)));



     -- !!!��������!!!

     -- �������� ���������� ������ ���, ������� ��� � ��������. ���� ����, ������, �����.
     PERFORM gpSetErased_Movement(Movement.Id, inSession) 
     FROM Movement  
          JOIN MovementLinkObject AS MLO_To
                                  ON MLO_To.MovementId = Movement.Id
                                 AND MLO_To.DescId = zc_MovementLinkObject_To() 
          JOIN ObjectLink AS ObjectLink_Unit_Branch 
                          ON ObjectLink_Unit_Branch.ObjectId = MLO_To.ObjectId 
                         AND ObjectLink_Unit_Branch.ChildObjectId = inBranchId
                         AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
          JOIN MovementBoolean AS MovementBoolean_isLoad 
                               ON MovementBoolean_isLoad.MovementId = Movement.Id
                              AND MovementBoolean_isLoad.DescId = zc_MovementBoolean_isLoad()
                              AND MovementBoolean_isLoad.valuedata = TRUE 
     LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                  ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                 AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
     WHERE Movement.DescId = zc_Movement_ReturnIn()
       AND Movement.OperDate BETWEEN inStartDate AND inEndDate
       AND MovementLinkObject_PaidKind.ObjectId = vbPaidKindId
       AND Movement.StatusId <> zc_Enum_Status_Erased();
--       AND NOT ((Movement.InvNumber, Movement.OperDate) IN (SELECT DISTINCT Sale1C.InvNumber
  --                      , Sale1C.OperDate
    --       FROM Sale1C             
      --    WHERE Sale1C.OperDate BETWEEN inStartDate AND inEndDate
        --    AND ((Sale1C.VIDDOC = '3') OR (Sale1C.VIDDOC = '4')) AND inBranchId = zfGetBranchFromUnitId (Sale1C.UnitId)));


     -- !!!��������!!!
    IF vbPaidKindId = zc_Enum_PaidKind_SecondForm()
    THEN
        -- �������� ����������
        PERFORM gpSetErased_Movement(Movement.Id, inSession) 
        FROM Movement
             JOIN MovementLinkObject AS MLO_From
                                     ON MLO_From.MovementId = Movement.Id
                                    AND MLO_From.DescId = zc_MovementLinkObject_From()
             JOIN ObjectLink AS ObjectLink_Unit_Branch 
                             ON ObjectLink_Unit_Branch.ObjectId = MLO_From.ObjectId 
                            AND ObjectLink_Unit_Branch.ChildObjectId = inBranchId
                            AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
             JOIN MovementBoolean AS MovementBoolean_isLoad 
                                  ON MovementBoolean_isLoad.MovementId = Movement.Id
                                 AND MovementBoolean_isLoad.DescId = zc_MovementBoolean_isLoad()
                                 AND MovementBoolean_isLoad.valuedata = TRUE 
        WHERE Movement.DescId = zc_Movement_Loss()
          AND Movement.OperDate BETWEEN inStartDate AND inEndDate
          AND Movement.StatusId <> zc_Enum_Status_Erased();
    END IF;


     -- ��������� ��������
     -- PERFORM lpInsert_MovementProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 22.09.14                        * 
 14.08.14                        * ����� ����� � ���������
 24.04.14                        * 
*/

-- ����
-- SELECT * FROM gpErasedSaleFrom1C ('01-01-2013'::TDateTime, '01-01-2014'::TDateTime, '')
