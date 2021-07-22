-- Function: gpInsertUpdate_MovementItem_ProductionPersonal()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_ProductionPersonal(Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_ProductionPersonal(Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_ProductionPersonal(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inBarCode_start       TVarChar   , -- ��������� �����
    IN inBarCode_end         TVarChar   , -- ��������� �����
    IN inBarCode_OrderClient TVarChar   , -- ����� �������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbPersonalId Integer;
   DECLARE vbProductId Integer;
   DECLARE vbMovementId_OrderClient Integer;
   DECLARE vbStartBegin TDateTime;
   DECLARE vbEndBegin   TDateTime;
   DECLARE vbAmount     TFloat;
   
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_ProductionPersonal());
     vbUserId := lpGetUserBySession (inSession);

     -- ������������ ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- ������ OrderClient
     IF TRIM (inBarCode_OrderClient) <> ''
     THEN
         IF CHAR_LENGTH (inBarCode_OrderClient) >= 12
         THEN -- �� ����� ����, �� ��� "��������" ����������� - 8 DAY
              vbMovementId_OrderClient:= (SELECT Movement.Id
                                          FROM (SELECT zfConvert_StringToNumber (SUBSTR (inBarCode_OrderClient, 4, 13-4)) AS MovementId
                                               ) AS tmp
                                               INNER JOIN Movement ON Movement.Id = tmp.MovementId
                                                                  AND Movement.DescId = zc_Movement_OrderClient()
                                                                  AND Movement.OperDate BETWEEN CURRENT_DATE - INTERVAL '60 DAY' AND CURRENT_DATE + INTERVAL '8 DAY'
                                                                  AND Movement.StatusId <> zc_Enum_Status_Erased()
                                         );
         ELSE -- �� InvNumber, �� ��� �������� ����������� - 8 DAY
              vbMovementId_OrderClient:= (SELECT Movement.Id
                                          FROM Movement
                                          WHERE Movement.InvNumber = TRIM (inBarCode_OrderClient)
                                            AND Movement.DescId = zc_Movement_OrderClient()
                                            AND Movement.OperDate BETWEEN CURRENT_DATE - INTERVAL '60 DAY' AND CURRENT_DATE + INTERVAL '8 DAY'
                                            AND Movement.StatusId <> zc_Enum_Status_Erased()
                                         );
         END IF;

         -- ��������
         IF COALESCE (vbMovementId_OrderClient, 0) = 0
         THEN
             RAISE EXCEPTION '������.�������� <����� �������> � � <%> �� ������.', inBarCode_OrderClient;
         END IF;

     END IF;

     vbProductId := (SELECT MovementLinkObject_Product.ObjectId       AS ProductId
                     FROM MovementLinkObject AS MovementLinkObject_Product
                     WHERE MovementLinkObject_Product.MovementId = vbMovementId_OrderClient
                       AND MovementLinkObject_Product.DescId = zc_MovementLinkObject_Product()
                     );

     IF COALESCE (inBarCode_start, '') = '' AND COALESCE (inBarCode_end, '') = ''
     THEN
         RETURN;
     END IF;
 
     IF COALESCE (inBarCode_start,'') <> ''
     THEN
         IF CHAR_LENGTH (inBarCode_start) >= 12
         THEN -- �� ����� ����
              vbPersonalId:= (SELECT Object.Id
                              FROM (SELECT zfConvert_StringToNumber (SUBSTR (inBarCode_start, 4, 13-4)) AS ObjectId
                                   ) AS tmp
                                    INNER JOIN Object ON Object.Id = tmp.ObjectId
                                                     AND Object.DescId = zc_Object_Personal()
                                                     AND Object.isErased = FALSE
                              );
         END IF;

         -- ��������
         IF COALESCE (vbPersonalId, 0) = 0
         THEN
             RAISE EXCEPTION '������.��������� � � <%> �� ������.', inBarCode_start;
         END IF;

         vbStartBegin := CURRENT_TIMESTAMP;
         vbEndBegin   := NULL ::TDateTime;
         vbAmount     := 0;
         ioId         := 0;
     END IF;

    IF COALESCE (inBarCode_end,'') <> ''
     THEN
         IF CHAR_LENGTH (inBarCode_start) >= 12
         THEN -- �� ����� ����
              vbPersonalId:= (SELECT Object.Id
                              FROM (SELECT zfConvert_StringToNumber (SUBSTR (inBarCode_end, 4, 13-4)) AS ObjectId
                                   ) AS tmp
                                    INNER JOIN Object ON Object.Id = tmp.ObjectId
                                                     AND Object.DescId = zc_Object_Personal()
                                                     AND Object.isErased = FALSE
                              );
         END IF;

         -- ��������
         IF COALESCE (vbPersonalId, 0) = 0
         THEN
             RAISE EXCEPTION '������.��������� � � <%> �� ������.', inBarCode_start;
         END IF;

         
         vbEndBegin   := CURRENT_TIMESTAMP;

         -- ������� ������ �� ���������� � ������ ����� ���������
         SELECT MovementItem.Id
              , MIDate_StartBegin.ValueData
        INTO ioId, vbStartBegin
         FROM MovementItem
              INNER JOIN MovementItemLinkObject AS MILO_Product
                                                ON MILO_Product.MovementItemId = MovementItem.Id
                                               AND MILO_Product.DescId = zc_MILinkObject_Product()
                                               AND MILO_Product.ObjectId = vbProductId

              LEFT JOIN MovementItemDate AS MIDate_StartBegin
                                         ON MIDate_StartBegin.MovementItemId = MovementItem.Id
                                        AND MIDate_StartBegin.DescId = zc_MIDate_StartBegin()
              LEFT JOIN MovementItemDate AS MIDate_EndBegin
                                         ON MIDate_EndBegin.MovementItemId = MovementItem.Id
                                        AND MIDate_EndBegin.DescId = zc_MIDate_EndBegin()
         WHERE MovementItem.MovementId = inMovementId
           AND MovementItem.DescId     =  zc_MI_Master()
           AND MovementItem.isErased   = FALSE
           AND MovementItem.ObjectId   = vbPersonalId
           AND MIDate_EndBegin.ValueData IS NULL
         ;   
         
         -- ���� ��� ������ ������ ������
         IF COALESCE (ioId,0) = 0
         THEN
             RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := '������.��� ������ ������ ������ ��� ���������� ����������' :: TVarChar
                                                   , inProcedureName := 'gpInsertUpdate_MovementItem_ProductionPersonal'   :: TVarChar
                                                   , inUserId        := vbUserId);
         END IF;
         
         --���� ������
         vbAmount := ( CAST ( COALESCE (date_part( 'day', vbEndBegin -vbStartBegin) * 24,0)      -- ���
                            + COALESCE (date_part( 'hours', vbEndBegin -vbStartBegin),0)      -- ����
                            + COALESCE (date_part( 'minute' , vbEndBegin - vbStartBegin)/60,0) AS NUMERIC (16,2)));  -- ������
     END IF;

     -- ��������� <������� ���������>
     SELECT tmp.ioId
            INTO ioId 
     FROM lpInsertUpdate_MovementItem_ProductionPersonal (ioId
                                                        , inMovementId
                                                        , vbPersonalId
                                                        , vbProductId
                                                        , vbStartBegin
                                                        , vbEndBegin
                                                        , vbAmount
                                                        , vbUserId
                                                        ) AS tmp;


     -- ����������� �������� �����
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

     -- ��������� ��������
     PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId, vbIsInsert);

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