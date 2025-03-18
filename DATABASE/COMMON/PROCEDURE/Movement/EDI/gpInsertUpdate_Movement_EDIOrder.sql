-- Function: gpInsertUpdate_Movement_EDI()

-- DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_EDIOrder (TVarChar, TDateTime, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_EDIOrder (TVarChar, TDateTime, TVarChar, TVarChar, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_EDIOrder(
    IN inOrderInvNumber      TVarChar  , -- ����� ���������
    IN inOrderOperDate       TDateTime , -- ���� ���������
    IN inGLN                 TVarChar  , -- ��� GLN - ����������
    IN inGLNPlace            TVarChar  , -- ��� GLN - ����� ��������
    IN gIsDelete             Boolean   , -- �����������, ��� � � ���������� �������� - ���� �� ������� ������ "�� �������", � "�� �����" - ��� ��������� ������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS TABLE (MovementId Integer, GoodsPropertyID Integer, isMetro Boolean, isLoad Boolean) -- ������������� �������)
AS
$BODY$
   DECLARE vbUserId   Integer;
   DECLARE vbIsInsert Boolean;

   DECLARE vbMovementId Integer;
   DECLARE vbGoodsPropertyId Integer;
   DECLARE vbPartnerId Integer;
   DECLARE vbJuridicalId Integer;
   DECLARE vbDescCode TVarChar;
   DECLARE vbisLoad Boolean;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_EDI());
     vbUserId:= lpGetUserBySession (inSession);

/*
if inSession <> '5' and 1=0
then
    RAISE EXCEPTION 'Error';
end if;
*/
     vbMovementId := NULL;


     -- ��������
     IF vbUserId <> 5
    AND 1 < (SELECT COUNT (*)
             FROM Movement
                  INNER JOIN MovementString AS MovementString_GLNPlaceCode
                                            ON MovementString_GLNPlaceCode.MovementId =  Movement.Id
                                           AND MovementString_GLNPlaceCode.DescId = zc_MovementString_GLNPlaceCode()
                                           AND MovementString_GLNPlaceCode.ValueData = inGLNPlace
             WHERE Movement.DescId = zc_Movement_EDI()
               AND Movement.OperDate = inOrderOperDate
               AND Movement.InvNumber = inOrderInvNumber
               AND Movement.StatusId <> zc_Enum_Status_Erased()
            )
     THEN
         -- ��������� ��������� ... �����������, �.�. �� �������� ��� ��� ��������
         /**/
         UPDATE Movement SET StatusId = zc_Enum_Status_Erased()
         WHERE Movement.DescId = zc_Movement_EDI()
           AND Movement.OperDate = inOrderOperDate
           AND Movement.Id IN (SELECT tmp.Id
                               FROM
                                   (SELECT Movement.*
                                         , Movement_Order.Id AS MovementId_find
                                         , ROW_NUMBER() OVER (PARTITION BY MovementString_GLNPlaceCode.ValueData, Movement.InvNumber
                                                              ORDER BY CASE WHEN Movement_Order.Id > 0 THEN 1 ELSE 2 END) AS Ord
                                    FROM Movement
                                         INNER JOIN MovementString AS MovementString_GLNPlaceCode
                                                                   ON MovementString_GLNPlaceCode.MovementId =  Movement.Id
                                                                  AND MovementString_GLNPlaceCode.DescId = zc_MovementString_GLNPlaceCode()
                                                                  -- AND MovementString_GLNPlaceCode.ValueData = '4820141820833'
                                         LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Order
                                                                        ON MovementLinkMovement_Order.MovementChildId = Movement.Id
                                                                       AND MovementLinkMovement_Order.DescId = zc_MovementLinkMovement_Order()
                                         LEFT JOIN Movement AS Movement_Order ON Movement_Order.Id = MovementLinkMovement_Order.MovementId
                                                                             -- AND Movement_Order.StatusId = zc_Enum_Status_Complete()
                                    WHERE Movement.DescId = zc_Movement_EDI()
                                      AND Movement.OperDate = inOrderOperDate
                                      -- AND Movement.InvNumber = '3369002860' -- '3147002592'
                                      AND Movement.StatusId <> zc_Enum_Status_Erased()
                                    ) AS tmp
                               WHERE tmp.Ord <> 1
                                 AND tmp.MovementId_find IS NULL
                              );
        /**/
        -- �������� ����� �����������
        IF 1 < (SELECT COUNT (*)
                FROM Movement
                     INNER JOIN MovementString AS MovementString_GLNPlaceCode
                                               ON MovementString_GLNPlaceCode.MovementId =  Movement.Id
                                              AND MovementString_GLNPlaceCode.DescId = zc_MovementString_GLNPlaceCode()
                                              AND MovementString_GLNPlaceCode.ValueData = inGLNPlace
                WHERE Movement.DescId = zc_Movement_EDI()
                  AND Movement.OperDate = inOrderOperDate
                  AND Movement.InvNumber = inOrderInvNumber
                  AND Movement.StatusId <> zc_Enum_Status_Erased()
               )
        THEN
            --
            RAISE EXCEPTION '������.�������� EDI � <%> �� <%> ��� ����� �������� � GLN = <%> �������� ������ 1 ����.', inOrderInvNumber, DATE (inOrderOperDate), inGLNPlace;
        END IF;

     END IF;


     -- ��������
     IF 0 < (SELECT COUNT (*)
             FROM Movement
                  INNER JOIN MovementString AS MovementString_GLNPlaceCode
                                            ON MovementString_GLNPlaceCode.MovementId =  Movement.Id
                                           AND MovementString_GLNPlaceCode.DescId = zc_MovementString_GLNPlaceCode()
                                           AND MovementString_GLNPlaceCode.ValueData = inGLNPlace
                  INNER JOIN MovementString AS MovementString_DealId
                                            ON MovementString_DealId.MovementId = Movement.Id
                                           AND MovementString_DealId.DescId     = zc_MovementString_DealId()
                                           AND MovementString_DealId.ValueData  <> ''
             WHERE Movement.DescId = zc_Movement_EDI()
               AND Movement.OperDate = inOrderOperDate
               AND Movement.InvNumber = inOrderInvNumber
               AND Movement.StatusId <> zc_Enum_Status_Erased()
            )
     THEN
         -- ����� �.�. �������� ��� ��������
         RETURN QUERY
            SELECT Movement.Id
                 , MLO_GoodsProperty.ObjectId AS GoodsPropertyID
                 , CASE WHEN MLO_GoodsProperty.ObjectId = 83954 -- �����
                             THEN TRUE
                        ELSE FALSE
                   END :: Boolean AS isMetro
                 , TRUE       AS isLoad
            FROM Movement
                  INNER JOIN MovementString AS MovementString_GLNPlaceCode
                                            ON MovementString_GLNPlaceCode.MovementId =  Movement.Id
                                           AND MovementString_GLNPlaceCode.DescId = zc_MovementString_GLNPlaceCode()
                                           AND MovementString_GLNPlaceCode.ValueData = inGLNPlace
                  INNER JOIN MovementString AS MovementString_DealId
                                            ON MovementString_DealId.MovementId = Movement.Id
                                           AND MovementString_DealId.DescId     = zc_MovementString_DealId()
                                           AND MovementString_DealId.ValueData  <> ''

                  LEFT JOIN MovementLinkObject AS MLO_GoodsProperty
                                               ON MLO_GoodsProperty.MovementId = Movement.Id
                                              AND MLO_GoodsProperty.DescId     = zc_MovementLinkObject_GoodsProperty()

            WHERE Movement.DescId = zc_Movement_EDI()
              AND Movement.OperDate = inOrderOperDate
              AND Movement.InvNumber = inOrderInvNumber
              AND Movement.StatusId <> zc_Enum_Status_Erased()
            LIMIT 1
           ;

         -- �����
         RETURN;

     END IF;


     -- ������� �������� (�� ���� ���� ����� - ���� GLN-���) + !!!�� ����� ��������!!!
     vbMovementId:= (SELECT Movement.Id
                     FROM Movement
                          INNER JOIN MovementString AS MovementString_GLNPlaceCode
                                                    ON MovementString_GLNPlaceCode.MovementId =  Movement.Id
                                                   AND MovementString_GLNPlaceCode.DescId = zc_MovementString_GLNPlaceCode()
                                                   AND MovementString_GLNPlaceCode.ValueData = inGLNPlace
                     WHERE Movement.DescId = zc_Movement_EDI()
                       AND Movement.OperDate = inOrderOperDate
                       AND Movement.InvNumber = inOrderInvNumber
                       AND Movement.StatusId <> zc_Enum_Status_Erased()
                     --AND vbUserId <> 5
                    );

     IF COALESCE(vbMovementId, 0) = 0 OR
        NOT EXISTS (SELECT 1 FROM MovementBoolean
                    WHERE MovementBoolean.MovementId = vbMovementId
                      AND MovementBoolean.DescId = zc_MovementBoolean_isLoad()
                      AND MovementBoolean.ValueData = TRUE)
     THEN

       -- ������������ ��������
       vbDescCode:= (SELECT MovementDesc.Code FROM MovementDesc WHERE Id = zc_Movement_OrderExternal());
       IF vbDescCode IS NULL
       THEN
           RAISE EXCEPTION '������ � ���������.<%>', inDesc;
       END IF;


       -- ���� �� �����
       IF COALESCE (vbMovementId, 0) = 0
       THEN
           -- ����� ��������� �� ������������
           vbIsInsert:= TRUE;
           -- ��������� <��������>
           vbMovementId := lpInsertUpdate_Movement (vbMovementId, zc_Movement_EDI(), inOrderInvNumber, inOrderOperDate, NULL);
       ELSE
           vbIsInsert:= FALSE;
       END IF;

       -- ���������
       PERFORM lpInsertUpdate_MovementString (zc_MovementString_Desc(), vbMovementId, vbDescCode);

       IF inGLN <> '' THEN
          PERFORM lpInsertUpdate_MovementString (zc_MovementString_GLNCode(), vbMovementId, inGLN);
       END IF;

       IF inGLNPlace <> '' THEN
          PERFORM lpInsertUpdate_MovementString (zc_MovementString_GLNPlaceCode(), vbMovementId, inGLNPlace);
          -- �������� ���������� ����� � ������ ��������
          vbPartnerId := COALESCE((SELECT MIN (ObjectId)
                      FROM ObjectString WHERE DescId = zc_ObjectString_Partner_GLNCode() AND ValueData = inGLNPlace), 0);
          IF vbPartnerId <> 0 THEN
             PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Partner(), vbMovementId, vbPartnerId);
          END IF;
       END IF;


       IF vbPartnerId <> 0 THEN -- ������� �� ���� �� �����������
          vbJuridicalId := COALESCE((SELECT ChildObjectId FROM ObjectLink WHERE DescId = zc_ObjectLink_Partner_Juridical() AND ObjectId = vbPartnerId), 0);
       END IF;

       IF COALESCE (vbJuridicalId, 0) <> 0 THEN
          -- ��������� <�� ����>
          PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Juridical(), vbMovementId, vbJuridicalId);

          -- ��������� <����>
          PERFORM lpInsertUpdate_MovementString (zc_MovementString_OKPO(), vbMovementId, (SELECT OKPO FROM ObjectHistory_JuridicalDetails_View WHERE JuridicalId = vbJuridicalId));

          -- ����� <������������� �������>
          -- vbGoodsPropertyID := (SELECT ChildObjectId FROM ObjectLink WHERE DescId = zc_ObjectLink_Juridical_GoodsProperty() AND ObjectId = vbJuridicalId);
          vbGoodsPropertyId := zfCalc_GoodsPropertyId ((SELECT MLO_Contract.ObjectId FROM MovementLinkObject AS MLO_Contract WHERE MLO_Contract.MovementId = vbMovementId AND MLO_Contract.DescId = zc_MovementLinkObject_Contract())
                                                     , vbJuridicalId
                                                     , vbPartnerId
                                                      );
          -- ��������� <������������� �������>
          PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_GoodsProperty(), vbMovementId, vbGoodsPropertyId);

       END IF;


       -- ������ ���� �������� ����� � EXE
       -- PERFORM lpInsert_Movement_EDIEvents(vbMovementId, '�������� ORDER �� EDI', vbUserId);


       -- ��������
       IF 1 < (SELECT COUNT (*)
               FROM Movement
                    INNER JOIN MovementString AS MovementString_GLNPlaceCode
                                              ON MovementString_GLNPlaceCode.MovementId =  Movement.Id
                                             AND MovementString_GLNPlaceCode.DescId = zc_MovementString_GLNPlaceCode()
                                             AND MovementString_GLNPlaceCode.ValueData = inGLNPlace
               WHERE Movement.DescId = zc_Movement_EDI()
                 AND Movement.OperDate = inOrderOperDate
                 AND Movement.InvNumber = inOrderInvNumber
                 AND Movement.StatusId <> zc_Enum_Status_Erased())
       THEN
           RAISE EXCEPTION '������.�������� EDI � <%> �� <%> ��� ����� �������� � GLN = <%> �������� ������ 1 ����. ��������� �������� ����� 25 ���.', inOrderInvNumber, DATE (inOrderOperDate), inGLNPlace;
       END IF;


       -- �������� ����� ������������
       IF vbIsInsert = TRUE
       THEN
           PERFORM lpInsert_LockUnique (inKeyData:= 'Movement'
                                          || ';' || zc_Movement_EDI() :: TVarChar
                                          || ';' || inOrderInvNumber
                                          || ';' || zfConvert_DateToString (inOrderOperDate)
                                          || ';' || inGLNPlace
                                      , inUserId:= vbUserId);
       END IF;

       vbisLoad := False;
     ELSE

       vbGoodsPropertyId := (SELECT MovementLinkObject.ObjectId
                             FROM MovementLinkObject
                             WHERE MovementLinkObject.MovementId = vbMovementId
                               AND MovementLinkObject.DescId = zc_MovementLinkObject_GoodsProperty());

       vbisLoad := True;
     END IF;

     -- ��������� ��������
     PERFORM lpInsert_MovementProtocol (vbMovementId, vbUserId, vbIsInsert);


IF vbUserId = 5 AND 1=0
THEN
    RAISE EXCEPTION '������.Test PartnerId = %', vbPartnerId;
END IF;

     RETURN QUERY
     SELECT vbMovementId
          , vbGoodsPropertyID
          , CASE WHEN vbGoodsPropertyID = 83954 -- �����
                      THEN TRUE
                 ELSE FALSE
            END :: Boolean AS isMetro
          , vbisLoad       AS isLoad
           ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 29.05.14                         *

*/

-- ����
--
-- select * from gpInsertUpdate_Movement_EDIOrder(inOrderInvNumber := 'MAI�B007537' , inOrderOperDate := ('21.01.2021')::TDateTime , inGLN := '9864066853281' , inGLNPlace := '9864232336358' , gIsDelete := 'True' ,  inSession := '14610');
