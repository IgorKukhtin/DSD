-- Function: gpRewiring_Slave_MovementId (INTEGER, TVarChar)

DROP FUNCTION IF EXISTS _replica.gpRewiring_Slave_MovementId (INTEGER, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION _replica.gpRewiring_Slave_MovementId(
    IN inMovementId        INTEGER,
    IN inIsNoHistoryCost   Boolean              , --
    IN inSession           TVarChar    -- ������ ������������
)
RETURNS TABLE (Id                    INTEGER,
               MovementId            INTEGER,

               Transaction_Id        BIGINT,
               isErrorRewiring       Boolean,
               OperDate              TDateTime,

               ErrorData             TBlob) 
AS
$BODY$
   DECLARE vbUserId    Integer;

   DECLARE vbMovementDescId Integer;
   DECLARE vbStatusId Integer;
   DECLARE vbId Integer;
   DECLARE vbOperDate TDateTime;

   DECLARE text_var1   Text;
   DECLARE text_var2   Text;
      
   DECLARE vbisComplete Boolean;
   DECLARE vbTransaction_Id BIGINT;
BEGIN
   -- !!! ��� �������� !!!
   -- ioId := (SELECT Id FROM Object WHERE ObjectCode=inCode AND DescId =zc_Object_Account());

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Account());
   vbUserId:= inSession::Integer;

   -- �����
   SELECT Movement.DescId, Movement.StatusId, Movement.OperDate 
   INTO vbMovementDescId, vbStatusId, vbOperDate 
   FROM Movement WHERE Movement.Id = inMovementId;
   
   -- !!!�����!!!
   IF vbStatusId <> zc_Enum_Status_Complete() THEN RETURN; END IF;

   -- !!!��������!!!
   IF COALESCE (vbMovementDescId, 0) = 0
   THEN
       RAISE EXCEPTION 'NOT FIND, inMovementId = %', inMovementId;
   END IF;

   vbisComplete := False;
   
   BEGIN
   
     vbTransaction_Id := txid_current();
        
     PERFORM gpComplete_All_Sybase (inMovementId:= inMovementId, inIsNoHistoryCost := inIsNoHistoryCost, inSession:= inSession);   

     vbisComplete := True;

     /*raise notice '�������� %', (select Count(*) from _replica.MovementItemContainer_Rewiring where MovementItemContainer_Rewiring.MovementId = inMovementId); 
     raise notice '�������� %', (select Count(*) from _replica.MovementProtocol_Rewiring where MovementProtocol_Rewiring.MovementId = inMovementId); 
     raise notice '���� %', (select Count(*) from _replica.table_update_data AS UD WHERE UD.last_modified >= CURRENT_DATE); */
     
     -- ��� ����� ��������������
     -- RAISE EXCEPTION '�����������'; 
     
   EXCEPTION
      WHEN others THEN
        GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT, text_var2 = PG_EXCEPTION_DETAIL;
   END;
   
   -- ������� � ��������� �� ������������ � ��� ������ �� ���������
   DELETE FROM _replica.RewiringProtocol 
   WHERE RewiringProtocol.MovementId = inMovementId 
     AND RewiringProtocol.isErrorRewiring = FALSE 
     AND RewiringProtocol.isProcessed = False;

   -- �������� �������� ������������
   INSERT INTO _replica.RewiringProtocol (MovementId, Transaction_Id, isErrorRewiring, OperDate, ErrorData)
   VALUES (inMovementId, vbTransaction_Id, NOT vbisComplete, CURRENT_TIMESTAMP, text_var1||COALESCE('; '||text_var2, ''))
   RETURNING RewiringProtocol.id INTO vbId;
   
   -- ���������
   RETURN QUERY
   SELECT RewiringProtocol.Id
        , RewiringProtocol.MovementId
        , RewiringProtocol.Transaction_Id
        , RewiringProtocol.isErrorRewiring
        , RewiringProtocol.OperDate
        , RewiringProtocol.ErrorData  
   FROM _replica.RewiringProtocol
   WHERE RewiringProtocol.Id = vbId;
      
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

  
/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 11.02.23                                                       * 
*/

-- ����
-- 
-- select * from _replica.MovementItemContainer_Rewiring
-- select * from _replica.MovementProtocol_Rewiring
-- select * from _replica.RewiringProtocol

-- select * from _replica.gpRewiring_Slave_MovementId(26065315, True, '0');