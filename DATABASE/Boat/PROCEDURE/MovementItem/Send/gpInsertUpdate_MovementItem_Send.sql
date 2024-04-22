-- Function: gpInsertUpdate_MovementItem_OrderClient()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Send(Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TVarChar, TVarChar, TVarChar, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Send(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inMovementId_OrderClient Integer, -- ����� �������
    IN inMovementId_OrderTop Integer, -- ����� ������� �� �����
    IN inGoodsId             Integer   , -- ������
    IN ioAmount              TFloat    , -- ����������
    IN inOperPrice           TFloat    , -- ���� �� �������
    IN inCountForPrice       TFloat    , -- ���� �� ���.
    IN inPartNumber          TVarChar  , --� �� ��� ��������
 INOUT ioPartionCellName     TVarChar  , -- ��� ��� ��������
    IN inComment             TVarChar  , --
 INOUT ioIsOn                Boolean   , -- ���
   OUT outIsErased           Boolean   , -- ������
   OUT outMovementId_OrderClient Integer   , --
   OUT outInvNumber_OrderClient  TVarChar  ,
   OUT outProductName        TVarChar  ,
   OUT outFromName           TVarChar  ,
   OUT outCIN                TVarChar  ,
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS RECORD AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbPartionCellId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_Send());
     vbUserId := lpGetUserBySession (inSession);

     -- ���� ���� ������������
     IF EXISTS (SELECT MovementItem.Id
                FROM MovementItem 
                WHERE MovementItem.MovementId = inMovementId
                  AND MovementItem.DescId     = zc_MI_Scan())
     THEN
       RAISE EXCEPTION '������.�������� �������� ��������� �� ���������� ���������� ����������.';
     END IF;

     -- ����� �����
     IF ioId < 0
     THEN
             -- ��������
             IF 1 < (SELECT COUNT(*) FROM MovementItem AS MI
                                 LEFT JOIN MovementItemString AS MIString_PartNumber
                                                              ON MIString_PartNumber.MovementItemId = MI.Id
                                                             AND MIString_PartNumber.DescId = zc_MIString_PartNumber()
                     WHERE MI.MovementId = inMovementId AND MI.DescId = zc_MI_Master() AND MI.isErased = FALSE
                       AND MI.ObjectId = inGoodsId
                       AND COALESCE (MIString_PartNumber.ValueData,'') = COALESCE (inPartNumber,'')
                     )
             THEN
                 RAISE EXCEPTION '������.������� ��������� ����� � ����� �������������.%<%>.', CHR (13), lfGet_Object_ValueData (inGoodsId);
             END IF;
             -- �����
             ioId:= (SELECT MI.Id FROM MovementItem AS MI
                                 LEFT JOIN MovementItemString AS MIString_PartNumber
                                                              ON MIString_PartNumber.MovementItemId = MI.Id
                                                             AND MIString_PartNumber.DescId = zc_MIString_PartNumber()
                     WHERE MI.MovementId = inMovementId AND MI.DescId = zc_MI_Master() AND MI.isErased = FALSE
                       AND MI.ObjectId = inGoodsId
                       AND COALESCE (MIString_PartNumber.ValueData,'') = COALESCE (inPartNumber,'')
                     );
         --
         ioAmount:= ioAmount + COALESCE ((SELECT MI.Amount FROM MovementItem AS MI WHERE MI.Id = ioId), 0);

     END IF;

     -- ������������ ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) <= 0;

     -- ������
     IF vbIsInsert = TRUE THEN ioIsOn:= TRUE; END IF;

     IF EXISTS (SELECT 1 FROM MovementItem WHERE MovementItem.Id = ioId AND MovementItem.isErased = TRUE)
     THEN
         -- ���� ������������
         outIsErased := gpMovementItem_Send_SetUnErased (ioId, inSession);
     ENd IF;

    IF COALESCE (inMovementId_OrderClient,0) = 0
    THEN
        inMovementId_OrderClient := inMovementId_OrderTop;
    END IF;

     --������� ������ ��������, ���� ��� ����� �������
     IF COALESCE (ioPartionCellName, '') <> '' THEN
         -- !!!����� �� !!!
         --���� ����� ��� ���� �� ����, ����� �� ��������
         IF zfConvert_StringToNumber (ioPartionCellName) <> 0
         THEN
             vbPartionCellId:= (SELECT Object.Id
                                FROM Object
                                WHERE Object.ObjectCode = zfConvert_StringToNumber (ioPartionCellName)
                                  AND Object.DescId     = zc_Object_PartionCell()
                               );
             --���� �� ����� ������
             IF COALESCE (vbPartionCellId,0) = 0
             THEN
                 RAISE EXCEPTION '������.�� ������� ������ � ����� <%>.', ioPartionCellName;
             END IF;
         ELSE
             vbPartionCellId:= (SELECT Object.Id
                                FROM Object
                                WHERE UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (ioPartionCellName))
                                  AND Object.DescId     = zc_Object_PartionCell()
                               );
             --���� �� ����� �������
             IF COALESCE (vbPartionCellId,0) = 0
             THEN
                 --
                 vbPartionCellId := gpInsertUpdate_Object_PartionCell (ioId	     := 0                                            ::Integer
                                                                     , inCode    := lfGet_ObjectCode(0, zc_Object_PartionCell()) ::Integer
                                                                     , inName    := TRIM (ioPartionCellName)                     ::TVarChar
                                                                     , inLevel   := 0           ::TFloat
                                                                     , inComment := ''          ::TVarChar
                                                                     , inSession := inSession   ::TVarChar
                                                                      );

             END IF;
         END IF;
         --
         ioPartionCellName := (SELECT Object.ValueData FROM Object WHERE Object.Id = vbPartionCellId);
     ELSE
         vbPartionCellId := NULL ::Integer;
     END IF;


     -- ��������� <������� ���������>
     SELECT tmp.ioId
            INTO ioId
     FROM lpInsertUpdate_MovementItem_Send (ioId
                                          , inMovementId
                                          , inMovementId_OrderClient
                                          , inGoodsId
                                          , vbPartionCellId  --inPartionCellId
                                          , ioAmount
                                          , inOperPrice
                                          , inCountForPrice
                                          , inPartNumber
                                          , inComment
                                          , vbUserId
                                           ) AS tmp;

     -- (��������� �.�. ���� ������ ��� �����-�� ��������� � ������ �� ������ ��� ������� ������)
     IF COALESCE (ioIsOn, FALSE) = FALSE
     THEN
         -- ������ ������� �� ��������
         outIsErased := gpMovementItem_Send_SetErased (ioId, inSession);
     ENd IF;



     SELECT Movement_OrderClient.Id                                   AS MovementId_OrderClient
          , zfCalc_InvNumber_isErased ('', Movement_OrderClient.InvNumber, Movement_OrderClient.OperDate, Movement_OrderClient.StatusId) AS InvNumber_OrderClient
          , Object_From.ValueData                                     AS FromName
          , zfCalc_ValueData_isErased (Object_Product.ValueData, Object_Product.isErased) AS ProductName
          , zfCalc_ValueData_isErased (ObjectString_CIN.ValueData,       Object_Product.isErased) AS CIN
   INTO outMovementId_OrderClient
      , outInvNumber_OrderClient
      , outFromName
      , outProductName
      , outCIN
     FROM Movement AS Movement_OrderClient
          LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                       ON MovementLinkObject_From.MovementId = Movement_OrderClient.Id
                                      AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
          LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

          LEFT JOIN MovementLinkObject AS MovementLinkObject_Product
                                       ON MovementLinkObject_Product.MovementId = Movement_OrderClient.Id
                                      AND MovementLinkObject_Product.DescId = zc_MovementLinkObject_Product()
          LEFT JOIN Object AS Object_Product ON Object_Product.Id = MovementLinkObject_Product.ObjectId

          LEFT JOIN ObjectString AS ObjectString_CIN
                                 ON ObjectString_CIN.ObjectId = Object_Product.Id
                                AND ObjectString_CIN.DescId = zc_ObjectString_Product_CIN()
     WHERE Movement_OrderClient.Id = inMovementId_OrderClient
     ;

     -- ����������� �������� �����
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 09.01.24         *
 15.12.22         *
 16.09.21         *
 23.06.21         *
*/

-- ����
--