-- Function: gpInsertUpdate_MovementItem_IncomeAsset()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_IncomeAsset (Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_IncomeAsset (Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_IncomeAsset (Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_IncomeAsset(
 INOUT ioId                    Integer   , -- ���� ������� <������� ���������>
    IN inMovementId            Integer   , -- ���� ������� <��������>
    IN inGoodsId               Integer   , -- ������
    IN inUnitId                Integer   , -- �������������
    IN inAssetId               Integer   , -- ��� ��
    IN inMIId_Invoice          Integer   , -- ������� ��������� C���
 INOUT ioAmount                TFloat    , -- ����������
    IN inPrice                 TFloat    , -- ����
 INOUT ioCountForPrice         TFloat    , -- ���� �� ����������
   OUT outAmountSumm           TFloat    , -- ����� ���������
 INOUT ioInvNumber_Asset       TVarChar  , -- 
 INOUT ioInvNumber_Asset_save  TVarChar  , -- 
   OUT outCurrencyDocumentId   Integer   ,
   OUT outCurrencyDocumentName TVarChar  ,
    IN inSession               TVarChar    -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCurrencyId Integer;              --������ ���.���������
   DECLARE vbCurrencyId_Invoice Integer;      --������ �����
   DECLARE vbMovementId_Invoice Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_IncomeAsset());
     vbUserId:= lpGetUserBySession (inSession);


     --���������� ������ �� �����, ���� ������� ����� � ������ ������� , ����� ������
     --������ �� ����� ���.
     vbCurrencyId := (SELECT MovementLinkObject_CurrencyDocument.ObjectId
                      FROM MovementLinkObject AS MovementLinkObject_CurrencyDocument
                      WHERE MovementLinkObject_CurrencyDocument.MovementId = inMovementId
                        AND MovementLinkObject_CurrencyDocument.DescId = zc_MovementLinkObject_CurrencyDocument()
                      );
     --������ �� ���. ����
     vbCurrencyId_Invoice := (SELECT MovementLinkObject_CurrencyDocument.ObjectId
                              FROM MovementLinkObject AS MovementLinkObject_CurrencyDocument
                              WHERE MovementLinkObject_CurrencyDocument.MovementId = (SELECT MovementItem.MovementId
                                                                                      FROM MovementItem
                                                                                      WHERE MovementItem.Id = inMIId_Invoice 
                                                                                        AND MovementItem.DescId = zc_MI_Master()
                                                                                      )
                                AND MovementLinkObject_CurrencyDocument.DescId = zc_MovementLinkObject_CurrencyDocument()
                              );

     --���� ������� ����� � ������ ������� , ����� ������
     IF COALESCE (vbCurrencyId,0) <> 0 AND COALESCE (vbCurrencyId_Invoice,0) <> COALESCE (vbCurrencyId,0)
     THEN
         RAISE EXCEPTION '������.������ ���������� ����� �� ��������� � ������� �������� ���������.';
     END IF;
 
     --���������� � ����� ������ ���. �� �����
     outCurrencyDocumentId := vbCurrencyId_Invoice;
     outCurrencyDocumentName := lfGet_Object_ValueData_sh (outCurrencyDocumentId);

     --��������� ������ � ���� ���.
     /*IF COALESCE (vbCurrencyId,0) = 0 OR (SELECT COUNT (*)
                                          FROM MovementItem
                                          WHERE MovementItem.MovementId = inMovementId
                                            AND MovementItem.DescId = zc_MI_Master()
                                            AND MovementItem.isErased = FALSE
                                          ) = 1
     THEN
          -- ��������� ����� � <������ (���������)>
          PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_CurrencyDocument(), inMovementId, outCurrencyDocumentId);
     END IF;
     */
     --


     -- �������� �������� <���� �� ����������>
     IF COALESCE (ioCountForPrice, 0) = 0 THEN ioCountForPrice := 1; END IF;

     -- ���������
     ioId:= lpInsertUpdate_MovementItem_IncomeAsset (ioId                 := ioId
                                                   , inMovementId         := inMovementId
                                                   , inGoodsId            := inGoodsId
                                                   , inUnitId             := inUnitId
                                                   , inAssetId            := inAssetId
                                                   , inMIId_Invoice       := inMIId_Invoice
                                                   , inAmount             := ioAmount
                                                   , inPrice              := inPrice
                                                   , inCountForPrice      := ioCountForPrice
                                                   , inUserId             := vbUserId
                                                    );


     -- ��������� �������� ����������� <�������� ��������>
     IF ioInvNumber_Asset <> ioInvNumber_Asset_save AND EXISTS (SELECT 1 FROM Object WHERE Object.Id = inGoodsId AND Object.DescId = zc_Object_Asset())
     THEN
         -- �������� ������������ ��� �������� <����������� �����> 
         PERFORM lpCheckUnique_ObjectString_ValueData (inGoodsId, zc_ObjectString_Asset_InvNumber(), ioInvNumber_Asset);
         -- ���������
         PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Asset_InvNumber(), inGoodsId, ioInvNumber_Asset);
         -- ��������� ��������
         PERFORM lpInsert_ObjectProtocol (inGoodsId, vbUserId);
     ELSEIF NOT EXISTS (SELECT 1 FROM Object WHERE Object.Id = inGoodsId AND Object.DescId = zc_Object_Asset())
     THEN
         ioInvNumber_Asset:= '';
     END IF;
     -- ��������������
     ioInvNumber_Asset_save:= ioInvNumber_Asset;


     -- ��������� ����� �� ��������, ��� �����
     outAmountSumm := CASE WHEN ioCountForPrice > 0
                                THEN CAST (ioAmount * inPrice / ioCountForPrice AS NUMERIC (16, 2))
                           ELSE CAST (ioAmount * inPrice AS NUMERIC (16, 2))
                      END;



END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 25.03.22         *
 27.08.16         * add AssetId
 06.08.16         *
 29.07.16         *
*/

-- ����
-- 