-- Function: gpInsertUpdate_MI_EDI()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_EDIOrder(Integer, Integer, TVarChar, TVarChar, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MI_EDIOrder(Integer, Integer, TVarChar, TVarChar, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_EDIOrder(
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inGoodsPropertyId     Integer   ,
    IN inGoodsName           TVarChar  , -- �����
    IN inGLNCode             TVarChar  , -- �����
    IN inAmountOrder         TFloat    , -- ���������� ������
    IN inPriceOrder          TFloat    , -- ���� �� �������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId   Integer;
   DECLARE vbIsInsert Boolean;

   DECLARE vbGoodsId        Integer;
   DECLARE vbGoodsKindId    Integer;
   DECLARE vbMovementItemId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_EDI());
     vbUserId:= lpGetUserBySession (inSession);


     -- ��������
     IF 0 < (SELECT COUNT (*)
             FROM Movement
                  INNER JOIN MovementString AS MovementString_DealId
                                            ON MovementString_DealId.MovementId = Movement.Id
                                           AND MovementString_DealId.DescId     = zc_MovementString_DealId()
                                           AND MovementString_DealId.ValueData  <> ''
             WHERE Movement.Id = inMovementId
            )
     THEN
         -- ����� �.�. �������� ��� ��������
         RETURN;
     END IF;


     -- ��������
     IF 1 < (WITH tmpMI AS (SELECT MovementItem.Id
                            FROM MovementItem
                            WHERE MovementItem.MovementId = inMovementId
                              AND MovementItem.DescId     = zc_MI_Master()
                              AND MovementItem.isErased   = FALSE
                           )
                , tmpMIS AS (SELECT MovementItemString.*
                             FROM MovementItemString
                             WHERE MovementItemString.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                               AND MovementItemString.DescId         = zc_MIString_GLNCode()
                            )
             -- ���������
             SELECT COUNT(*) FROM tmpMIS WHERE tmpMIS.ValueData = inGLNCode
            )
     THEN
         -- ��������� ��������� ... �����������, �.�. �� �������� ��� ��� ��������
         /**/
         UPDATE MovementItem SET isErased = TRUE
         WHERE MovementItem.MovementId = inMovementId
           AND MovementItem.DescId     = zc_MI_Master()
           AND MovementItem.isErased   = FALSE
           AND MovementItem.Id         IN (WITH tmpMI AS (SELECT MovementItem.Id
                                                          FROM MovementItem
                                                          WHERE MovementItem.MovementId = inMovementId
                                                            AND MovementItem.DescId = zc_MI_Master()
                                                            AND MovementItem.isErased = FALSE
                                                         )
                                              , tmpMIS AS (SELECT MovementItemString.*
                                                           FROM MovementItemString
                                                           WHERE MovementItemString.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                                                             AND MovementItemString.DescId         = zc_MIString_GLNCode()
                                                          )
                                           -- ���������
                                           SELECT tmp.MovementItemId
                                           FROM (SELECT tmpMIS.MovementItemId
                                                      , ROW_NUMBER() OVER (PARTITION BY tmpMIS.ValueData ORDER BY tmpMIS.MovementItemId DESC) AS Ord
                                                 FROM tmpMIS
                                                 WHERE tmpMIS.ValueData = inGLNCode
                                                ) AS tmp
                                           WHERE tmp.Ord <> 1
                                          );
         /**/

         -- �������� ����� �����������
         IF 1 < (WITH tmpMI AS (SELECT MovementItem.Id
                                FROM MovementItem
                                WHERE MovementItem.MovementId = inMovementId
                                  AND MovementItem.DescId     = zc_MI_Master()
                                  AND MovementItem.isErased   = FALSE
                               )
                    , tmpMIS AS (SELECT MovementItemString.*
                                 FROM MovementItemString
                                 WHERE MovementItemString.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                                   AND MovementItemString.DescId         = zc_MIString_GLNCode()
                                )
                 -- ���������
                 SELECT COUNT(*) FROM tmpMIS WHERE tmpMIS.ValueData = inGLNCode
                )
         THEN
             RAISE EXCEPTION '������.� ��������� EDI � <%> �� <%> ������������ ������ � GLN = <%>', (SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = inMovementId AND Movement.DescId = zc_Movement_EDI())
                                                                                                  , DATE ((SELECT Movement.OperDate  FROM Movement WHERE Movement.Id = inMovementId AND Movement.DescId = zc_Movement_EDI()))
                                                                                                  , inGLNCode;
        END IF;
     END IF;

     -- ������� ������� (�� ���� ���� ����� - ���� GLN-���)
     vbMovementItemId := COALESCE((WITH tmpMI AS (SELECT MovementItem.Id
                                                  FROM MovementItem
                                                  WHERE MovementItem.MovementId = inMovementId
                                                    AND MovementItem.DescId     = zc_MI_Master()
                                                    AND MovementItem.isErased   = FALSE
                                                 )
                                      , tmpMIS AS (SELECT MovementItemString.*
                                                   FROM MovementItemString
                                                   WHERE MovementItemString.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                                                     AND MovementItemString.DescId         = zc_MIString_GLNCode()
                                                  )
                                   -- ���������
                                   SELECT tmpMIS.MovementItemId FROM tmpMIS WHERE tmpMIS.ValueData = inGLNCode
                                  ), 0);

     -- ���� ���� �������������
     IF COALESCE (inGoodsPropertyId, 0) <> 0 AND TRIM (inGLNCode) <>''
     THEN
         -- ������� vbGoodsId � vbGoodsKindId
         SELECT ObjectLink_GoodsPropertyValue_Goods.ChildObjectId     AS GoodsId
              , ObjectLink_GoodsPropertyValue_GoodsKind.ChildObjectId AS GoodsKindId
                INTO vbGoodsId, vbGoodsKindId
         FROM ObjectString AS ObjectString_ArticleGLN
              JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsProperty
                              ON ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId      = ObjectString_ArticleGLN.objectid
                             AND ObjectLink_GoodsPropertyValue_GoodsProperty.DescId        = zc_ObjectLink_GoodsPropertyValue_GoodsProperty()
                             AND ObjectLink_GoodsPropertyValue_GoodsProperty.ChildObjectId = inGoodsPropertyId
              LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsKind
                                   ON ObjectLink_GoodsPropertyValue_GoodsKind.ObjectId = ObjectString_ArticleGLN.objectid
                                  AND ObjectLink_GoodsPropertyValue_GoodsKind.DescId   = zc_ObjectLink_GoodsPropertyValue_GoodsKind()
              LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_Goods
                                   ON ObjectLink_GoodsPropertyValue_Goods.ObjectId = ObjectString_ArticleGLN.objectid
                                  AND ObjectLink_GoodsPropertyValue_Goods.DescId   = zc_ObjectLink_GoodsPropertyValue_Goods()
         WHERE ObjectString_ArticleGLN.DescId    = zc_ObjectString_GoodsPropertyValue_ArticleGLN()
           AND ObjectString_ArticleGLN.ValueData = inGLNCode;
     END IF;


     -- ���������� ������� ��������/�������������
     vbIsInsert:= COALESCE (vbMovementItemId, 0) = 0;

     -- ��������� <������� ���������>
     vbMovementItemId := lpInsertUpdate_MovementItem (vbMovementItemId, zc_MI_Master(), vbGoodsId, inMovementId, inAmountOrder, NULL);

     -- ���������
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_GLNCode(), vbMovementItemId, inGLNCode);

     -- ���������
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_GoodsName(), vbMovementItemId, inGoodsName);

     -- ��������� ����� � <���� �������>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsKind(), vbMovementItemId, vbGoodsKindId);

     -- ��������� <���� �� �������>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), vbMovementItemId, inPriceOrder);

     -- ��������
     IF 1 < (WITH tmpMI AS (SELECT MovementItem.Id
                            FROM MovementItem
                            WHERE MovementItem.MovementId = inMovementId
                              AND MovementItem.DescId     = zc_MI_Master()
                              AND MovementItem.isErased   = FALSE
                           )
                , tmpMIS AS (SELECT MovementItemString.*
                             FROM MovementItemString
                             WHERE MovementItemString.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                               AND MovementItemString.DescId         = zc_MIString_GLNCode()
                            )
             -- ���������
             SELECT COUNT(*) FROM tmpMIS WHERE tmpMIS.ValueData = inGLNCode
            )
     THEN
         RAISE EXCEPTION '������.� ��������� EDI � <%> �� <%> ������������ ������ � GLN = <%>. ��������� �������� ����� 25 ���.'
                                                                                              , (SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = inMovementId AND Movement.DescId = zc_Movement_EDI())
                                                                                              , DATE ((SELECT Movement.OperDate  FROM Movement WHERE Movement.Id = inMovementId AND Movement.DescId = zc_Movement_EDI()))
                                                                                              , inGLNCode;
     END IF;


     -- �������� ����� ������������
     IF vbIsInsert = TRUE AND inGLNCode <> ''

     THEN
         PERFORM lpInsert_LockUnique (inKeyData:= 'MI'
                                        || ';' || zc_Movement_EDI() :: TVarChar
                                        || ';' || inMovementId :: TVarChar
                                        || ';' || inGLNCode
                                    , inUserId:= vbUserId);
     END IF;


     -- ������ 1 ���
     IF vbIsInsert = TRUE
     THEN
         -- ��������� ��������
         PERFORM lpInsert_MovementItemProtocol (vbMovementItemId, vbUserId, vbIsInsert);
     END IF;

IF vbUserId = 5 AND 1=0
THEN
    RAISE EXCEPTION '������.Test-ok-end % ', vbGoodsKindId;
END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 29.05.14                         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_MI_EDIOrder (inMovementId:= 16086413, inGoodsPropertyId:= 536616, inGoodsName:= '������� ���� ������� �/� �/� 1/2 �/� ���', inGLNCode:= '9-0034180', inAmountOrder:= 0.6, inPriceOrder:= 215.7, inSession:= '5')
