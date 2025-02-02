-- Function: gpInsertUpdate_ScaleCeh_Movement()

-- DROP FUNCTION IF EXISTS gpInsertUpdate_ScaleCeh_Movement (Integer, TDateTime, Integer, Integer, Integer, Integer, Boolean, TVarChar);
-- DROP FUNCTION IF EXISTS gpInsertUpdate_ScaleCeh_Movement (Integer, TDateTime, Integer, Integer, Integer, Integer, Boolean, Integer, TVarChar);
-- DROP FUNCTION IF EXISTS gpInsertUpdate_ScaleCeh_Movement (Integer, TDateTime, Integer, Integer, Integer, Integer, Integer, Boolean, Integer, TVarChar);
-- DROP FUNCTION IF EXISTS gpInsertUpdate_ScaleCeh_Movement (Integer, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Boolean, Integer, TVarChar);
-- DROP FUNCTION IF EXISTS gpInsertUpdate_ScaleCeh_Movement (Integer, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Boolean, Integer, TVarChar);
-- DROP FUNCTION IF EXISTS gpInsertUpdate_ScaleCeh_Movement (Integer, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Boolean, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_ScaleCeh_Movement (Integer, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Boolean, Integer, TVarChar, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_ScaleCeh_Movement(
    IN inId                  Integer   , -- ���� ������� <��������>
    IN inOperDate            TDateTime , -- ���� ���������
    IN inMovementDescId      Integer   , -- ��� ���������
    IN inMovementDescNumber  Integer   , -- ��� ���������
    IN inFromId              Integer   , -- �� ���� (� ���������)
    IN inToId                Integer   , -- ���� (� ���������)
    IN inSubjectDocId        Integer   , --
    IN inPersonalGroupId     Integer   , --
    IN inMovementId_Order    Integer   , -- ���� ��������� ������
    IN inIsProductionIn      Boolean   , --
    IN inBranchCode          Integer   , --
    IN inComment             TVarChar  , --
    IN inIsListInventory     Boolean   , -- �������������� ������ ��� ��������� �������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS TABLE (Id        Integer
             , InvNumber TVarChar
             , OperDate  TDateTime
              )
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbDocumentKindId Integer;
   DECLARE vbIsRePack Boolean;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_ScaleCeh_Movement());
     vbUserId:= lpGetUserBySession (inSession);
     
     
     -- ���������� ����
     inOperDate:= (SELECT gpGet_Scale_OperDate (inIsCeh       := TRUE
                                              , inBranchCode  := inBranchCode
                                              , inSession     := inSession
                                               ));

     -- ���������� <��� ���������>
     vbDocumentKindId:= (SELECT CASE WHEN TRIM (tmp.RetV) = '' THEN '0' ELSE TRIM (tmp.RetV) END :: Integer
                         FROM (SELECT gpGet_ToolsWeighing_Value (inLevel1      := 'ScaleCeh_' || inBranchCode
                                                               , inLevel2      := 'Movement'
                                                               , inLevel3      := 'MovementDesc_' || CASE WHEN inMovementDescNumber < 10 THEN '0' ELSE '' END || (inMovementDescNumber :: Integer) :: TVarChar
                                                               , inItemName    := 'DocumentKindId'
                                                               , inDefaultValue:= '0'
                                                               , inSession     := inSession
                                                                ) AS RetV
                              ) AS tmp
                        );

     IF inMovementDescId = zc_Movement_Send()
    AND inFromId = 8451 -- ��� ���������
    AND inToId   = zc_Unit_RK()
    THEN
        -- ���������� vbIsRePack
        vbIsRePack:= (SELECT CASE WHEN TRIM (tmp.RetV) ILIKE 'TRUE' THEN TRUE ELSE FALSE END :: Boolean
                      FROM (SELECT gpGet_ToolsWeighing_Value (inLevel1      := 'ScaleCeh_' || inBranchCode
                                                            , inLevel2      := 'Movement'
                                                            , inLevel3      := 'MovementDesc_' || CASE WHEN inMovementDescNumber < 10 THEN '0' ELSE '' END || (inMovementDescNumber :: Integer) :: TVarChar
                                                            , inItemName    := 'isRePack'
                                                            , inDefaultValue:= 'FALSE'
                                                            , inSession     := inSession
                                                             ) AS RetV
                           ) AS tmp
                     );
    ELSE
        vbIsRePack:= FALSE;
    END IF;
                        


     -- ���������
     inId:= gpInsertUpdate_Movement_WeighingProduction (ioId                  := inId
                                                      , inOperDate            := inOperDate
                                                      , inMovementDescId      := inMovementDescId
                                                      , inMovementDescNumber  := inMovementDescNumber
                                                      , inWeighingNumber      := CASE WHEN inId <> 0
                                                                                           THEN (SELECT MovementFloat.ValueData FROM MovementFloat WHERE MovementFloat.MovementId = inId AND MovementFloat.DescId = zc_MovementFloat_WeighingNumber())
                                                                                      WHEN inMovementDescId = zc_Movement_ProductionSeparate()
                                                                                           THEN 0 -- update ��� �������� ��������� (������ ��� ������������ - �� � ������)
                                                                                      WHEN inMovementDescId NOT IN (zc_Movement_ProductionSeparate(), zc_Movement_Inventory())
                                                                                           THEN 1
                                                                                      ELSE 1 + COALESCE ((SELECT MAX (COALESCE (MovementFloat_WeighingNumber.ValueData, 0))
                                                                                                          FROM Movement
                                                                                                               INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                                                                                                             ON MovementLinkObject_From.MovementId = Movement.Id
                                                                                                                                            AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                                                                                                                            AND MovementLinkObject_From.ObjectId = inFromId
                                                                                                               INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                                                                                                             ON MovementLinkObject_To.MovementId = Movement.Id
                                                                                                                                            AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                                                                                                                            AND MovementLinkObject_To.ObjectId = inToId
                                                                                                               INNER JOIN MovementFloat AS MovementFloat_MovementDesc
                                                                                                                                        ON MovementFloat_MovementDesc.MovementId =  Movement.Id
                                                                                                                                       AND MovementFloat_MovementDesc.DescId = zc_MovementFloat_MovementDesc()
                                                                                                                                       AND MovementFloat_MovementDesc.ValueData = inMovementDescId
                                                                                                               INNER JOIN MovementFloat AS MovementFloat_WeighingNumber
                                                                                                                                        ON MovementFloat_WeighingNumber.MovementId = Movement.Id
                                                                                                                                       AND MovementFloat_WeighingNumber.DescId = zc_MovementFloat_WeighingNumber()
                                                                                                          WHERE Movement.DescId = zc_Movement_WeighingProduction()
                                                                                                            AND Movement.OperDate = inOperDate
                                                                                                            AND Movement.StatusId <> zc_Enum_Status_Erased()
                                                                                                         ), 0)
                                                                              END :: Integer
                                                      , inFromId              := inFromId
                                                      , inToId                := inToId
                                                      , inDocumentKindId      := CASE WHEN vbDocumentKindId = 0 THEN NULL ELSE vbDocumentKindId END
                                                      , inSubjectDocId        := inSubjectDocId
                                                      , inPersonalGroupId     := inPersonalGroupId
                                                      , inMovementId_Order    := inMovementId_Order
                                                      , inPartionGoods        := (SELECT MovementString.ValueData FROM MovementString WHERE MovementString.MovementId = inId AND MovementString.DescId = zc_MovementString_PartionGoods())
                                                      , inIsProductionIn      := inIsProductionIn
                                                      , inComment             := inComment
                                                      , inSession             := inSession
                                                       );

     -- �������� ��-�� - �������������� ������ ��� ��������� �������
     IF inMovementDescId = zc_Movement_Inventory() AND inIsListInventory = TRUE
     THEN
          -- ���������
          PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_List(), inId, inIsListInventory);
     END IF;

     -- �������� ��-�� - vbIsRePack
     IF vbIsRePack = TRUE
     THEN
          -- ���������
          PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_isRePack(), inId, TRUE);
     END IF;

     -- �������� �������� <��� �������>
     IF NOT EXISTS (SELECT 1 FROM MovementFloat AS MF WHERE MF.MovementId = inId AND MF.DescId = zc_MovementFloat_BranchCode())
     THEN
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_BranchCode(), inId, inBranchCode);
     END IF;


     -- ���������
     RETURN QUERY
       SELECT Movement.Id
            , Movement.InvNumber
            , Movement.OperDate
       FROM Movement
       WHERE Movement.Id = inId;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 10.05.15                                        *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_ScaleCeh_Movement (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inAmountPartner:= 0, inAmountPacker:= 0, inPrice:= 1, inCountForPrice:= 1, inLiveWeight:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inAssetId:= 0, inSession:= '2')
