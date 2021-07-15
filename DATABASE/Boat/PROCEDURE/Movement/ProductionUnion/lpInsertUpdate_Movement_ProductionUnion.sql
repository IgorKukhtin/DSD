-- Function: gpInsertUpdate_Movement_ProductionUnion()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_ProductionUnion (Integer, TVarChar, TDateTime, Integer, Integer, TVarChar, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_ProductionUnion (Integer, Integer, TVarChar, TDateTime, Integer, Integer, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_ProductionUnion(
 INOUT ioId                  Integer   , -- ���� ������� <�������� �����������>
    IN inParentId            Integer   , --
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inOperDate            TDateTime , -- ���� ���������
    IN inFromId              Integer   , -- �� ����
    IN inToId                Integer   , -- ����
    IN inComment             TVarChar  , -- ����������
    IN inUserId              Integer     -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbIsInsert Boolean;
   DECLARE vbProductId Integer;
   DECLARE vbProductId_mi Integer;
   DECLARE vbMovementItemId Integer;
BEGIN
     -- ��������
     /*IF COALESCE (inFromId, 0) = 0 OR COALESCE (inToId, 0) = 0
     THEN
         RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := '������.������� ���� ���������� <������>.' :: TVarChar
                                               , inProcedureName := 'lpInsertUpdate_Movement_ProductionUnion'
                                               , inUserId        := inUserId
                                                );
     END IF;*/


     -- ���������� ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_ProductionUnion(), inInvNumber, inOperDate, inParentId, inUserId);

     -- ��������� ����� � <�� ���� >
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_From(), ioId, inFromId);
     -- ��������� ����� � <���� >
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_To(), ioId, inToId);
 
     -- ��������� <����������>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);

  
     -- ����������� �������� ����� �� ���������
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (ioId);


    -- !!!�������� ����� �������� ����������� �������!!!
     IF vbIsInsert = FALSE
     THEN
         -- ��������� �������� <���� �������������>
         PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Update(), ioId, CURRENT_TIMESTAMP);
         -- ��������� �������� <������������ (�������������)>
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Update(), ioId, inUserId);
     ELSE
         IF vbIsInsert = TRUE
         THEN
             -- ��������� �������� <���� ��������>
             PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Insert(), ioId, CURRENT_TIMESTAMP);
             -- ��������� �������� <������������ (��������)>
             PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Insert(), ioId, inUserId);
         END IF;
     END IF;


     -- ��������� ��������
     PERFORM lpInsert_MovementProtocol (ioId, inUserId, vbIsInsert);

     -----������
     -- ���������� ����� �� ������ � ������ ����  ���� ��� ����������
     vbProductId := (SELECT MovementLinkObject_Product.ObjectId       AS ProductId
                     FROM MovementLinkObject AS MovementLinkObject_Product
                     WHERE MovementLinkObject_Product.MovementId = inParentId
                       AND MovementLinkObject_Product.DescId = zc_MovementLinkObject_Product()
                     );

     IF COALESCE (vbProductId,0) <> 0
     THEN
          -- ���� ��� ���� ������ � ������ �� �������� �����, ���� ��� ������� ������
          SELECT MovementItem.Id
               , MovementItem.ObjectId
        INTO vbMovementItemId, vbProductId_mi
          FROM MovementItem
              INNER JOIN Object ON Object.Id = MovementItem.ObjectId
                               AND Object.DescId = zc_Object_Product()
          WHERE MovementItem.MovementId = ioId
            AND MovementItem.DescId = zc_MI_Master()
            AND MovementItem.isErased = FALSE
          ;
     
          -- ���������� ������� ��������/�������������
          vbIsInsert:= COALESCE (vbMovementItemId, 0) = 0;
          --���� ���������� ����� ������� ������
          IF vbIsInsert = FALSE AND (COALESCE(vbProductId,0) <> COALESCE(vbProductId_mi,0))
          THEN
              UPDATE MovementItem
               SET isErased = TRUE
              WHERE MovementItem.MovementId = ioId
                AND MovementItem.ParentId = COALESCE (vbMovementItemId,0)
                AND MovementItem.DescId = zc_MI_Child()
                AND MovementItem.isErased = FALSE;
          END IF;

     --
     PERFORM lpInsertUpdate_MovementItem_ProductionUnion (COALESCE (vbMovementItemId, 0)
                                                        , ioId
                                                        , vbProductId
                                                        , COALESCE (ObjectLink_ReceiptProdModel.ChildObjectId,0)
                                                        , 1  :: TFloat
                                                        , '' :: TVarChar
                                                        , inUserId
                                                        )
     FROM ObjectLink AS ObjectLink_ReceiptProdModel
     WHERE ObjectLink_ReceiptProdModel.ObjectId = vbProductId
       AND ObjectLink_ReceiptProdModel.DescId   = zc_ObjectLink_Product_ReceiptProdModel();

     END IF;
     
END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 12.07.21         *
*/

-- ����
--