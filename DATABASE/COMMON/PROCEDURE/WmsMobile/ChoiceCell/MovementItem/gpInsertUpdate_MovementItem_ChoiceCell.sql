-- Function: gpInsertUpdate_MovementItem_ChoiceCell()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_ChoiceCell (TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_ChoiceCell(
    IN inBarCode             TVarChar  , -- �������� ��. ������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbChoiceCellId Integer;
   DECLARE vbMovementId   Integer;
   DECLARE vbOperDate     TDateTime;

   DECLARE vbGoodsId     Integer;
   DECLARE vbGoodsKindId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_ChoiceCell());
     vbUserId:= lpGetUserBySession (inSession);

     -- ���� ���� �����
     IF COALESCE (inBarCode,'') <> ''
     THEN
         -- �� ����
         IF CHAR_LENGTH (inBarCode) < 12
         THEN vbChoiceCellId:= (SELECT Object.Id
                                FROM (SELECT zfConvert_StringToNumber (inBarCode) AS ObjectCode
                                     ) AS tmp
                                      INNER JOIN Object ON Object.ObjectCode = tmp.ObjectCode
                                                       AND Object.DescId = zc_Object_ChoiceCell()
                                                       AND Object.isErased = FALSE
                                WHERE tmp.ObjectCode > 0
                                );

         -- �� ����� ����
         ELSEIF CHAR_LENGTH (inBarCode) = 12
         THEN
              vbChoiceCellId:= (SELECT Object.Id
                                FROM (SELECT zfConvert_StringToNumber (SUBSTR (inBarCode, 4, 13-4)) AS ObjectId
                                     ) AS tmp
                                      INNER JOIN Object ON Object.Id = tmp.ObjectId
                                                       AND Object.DescId = zc_Object_ChoiceCell()
                                                       AND Object.isErased = FALSE
                                );
         END IF;

     END IF;


     -- ��������
     IF COALESCE (vbChoiceCellId, 0) = 0
     THEN
        --
         RAISE EXCEPTION '������.������ ������ � % <%> �� �������.'
                        , CASE WHEN CHAR_LENGTH (inBarCode) < 12 THEN '�����' ELSE '����������' END
                        , inBarCode;
     END IF;


     -- ����� ����� �������� ��� ���� ������ ������
     SELECT COALESCE (ObjectLink_Goods.ChildObjectId, 0)       AS GoodsId
          , COALESCE (ObjectLink_GoodsKind.ChildObjectId, 0)   AS GoodsKindId
            INTO vbGoodsId, vbGoodsKindId
     FROM ObjectLink AS ObjectLink_Goods
          LEFT JOIN ObjectLink AS ObjectLink_GoodsKind
                               ON ObjectLink_GoodsKind.ObjectId = ObjectLink_Goods.ObjectId
                              AND ObjectLink_GoodsKind.DescId = zc_ObjectLink_ChoiceCell_GoodsKind()
     WHERE ObjectLink_Goods.ObjectId = vbChoiceCellId
       AND ObjectLink_Goods.DescId   = zc_ObjectLink_ChoiceCell_Goods()
    ;

     -- ���� � ����������� �� �����
     vbOperDate:= gpGet_Scale_OperDate (inIsCeh:= FALSE, inBranchCode:= 1, inSession:= inSession);

     -- ��������
     IF 1 < (SELECT COUNT(*) FROM Movement WHERE Movement.DescId = zc_Movement_ChoiceCell() AND Movement.OperDate = vbOperDate AND Movement.StatusId <> zc_Enum_Status_Erased())
     THEN
         --
         RAISE EXCEPTION '������.������� ��������� ���������� <%> �� <%>.������ ����� �������.'
                       , (SELECT MovementDesc.ItemName FROM MovementDesc WHERE MovementDesc.Id = zc_Movement_ChoiceCell())
                       , vbOperDate
                        ;
     END IF;


     -- ������� ����� ��������
     vbMovementId:= (SELECT Movement.Id FROM Movement WHERE Movement.DescId = zc_Movement_ChoiceCell() AND Movement.OperDate = vbOperDate AND Movement.StatusId <> zc_Enum_Status_Erased());


     IF COALESCE (vbMovementId,0) = 0
     THEN
         vbMovementId := lpInsertUpdate_Movement_ChoiceCell (ioId          := 0
                                                           , inInvNumber   := CAST (NEXTVAL ('movement_ChoiceCell_seq') AS TVarChar)
                                                           , inOperDate    := vbOperDate
                                                           , inUserId      := vbUserId
                                                            )AS tmp;
     END IF;


    -- ���������
    PERFORM lpInsertUpdate_MovementItem_ChoiceCell (ioId                     := 0
                                                  , inMovementId             := vbMovementId
                                                  , inChoiceCellId           := tmp.ChoiceCellId
                                                  , inGoodsId                := vbGoodsId
                                                  , inGoodsKindId            := vbGoodsKindId
                                                  , inPartionGoodsDate       := tmp.PartionGoodsDate
                                                  , inPartionGoodsDate_next  := tmp.PartionGoodsDate_next
                                                  , inUserId                 := vbUserId
                                                   )
           FROM (WITH -- ��� ����������� ����� �������� - ������ + ������ "�����"
                      tmpPartionCell_mi AS (SELECT DISTINCT lpSelect.PartionCellId, lpSelect.GoodsId, lpSelect.GoodsKindId, lpSelect.PartionGoodsDate
                                            FROM lpSelect_Object_PartionCell_mi (inGoodsId:= vbGoodsId, inGoodsKindId:= vbGoodsKindId) AS lpSelect
                                           )
                      -- ������ ��������� ������ � ������ "�����"
                    , tmpPartionCell_RK AS (SELECT tmpMI.GoodsId, tmpMI.GoodsKindId, tmpMI.PartionGoodsDate
                                                   -- � �/�
                                                 , ROW_NUMBER() OVER (PARTITION BY tmpMI.GoodsId, tmpMI.GoodsKindId ORDER BY tmpMI.PartionGoodsDate DESC) AS Ord
                                            FROM tmpPartionCell_mi AS tmpMI
                                            -- ������ = ������ "�����"
                                            WHERE tmpMI.PartionCellId = zc_PartionCell_RK()
                                           )
                   -- ������ ������ ������ � ������ ��������
                 ,  tmpPartionCell_real AS (SELECT tmpMI.GoodsId, tmpMI.GoodsKindId, tmpMI.PartionGoodsDate
                                                   -- � �/�
                                                 , ROW_NUMBER() OVER (PARTITION BY tmpMI.GoodsId, tmpMI.GoodsKindId ORDER BY tmpMI.PartionGoodsDate ASC) AS Ord
                                            FROM tmpPartionCell_mi AS tmpMI
                                            -- ������ = ������ ��������
                                            WHERE tmpMI.PartionCellId <> zc_PartionCell_RK()
                                           )
              -- ���������
              SELECT
                     Object_ChoiceCell.Id                   AS ChoiceCellId
                     -- ��������� ������ � ������ "�����"
                   , tmpPartionCell_RK.PartionGoodsDate   :: TDateTime AS PartionGoodsDate
                     -- ������ ������ � ������ ��������
                   , tmpPartionCell_real.PartionGoodsDate :: TDateTime AS PartionGoodsDate_next

                   , (zfFormat_BarCode (zc_BarCodePref_Object(), Object_ChoiceCell.Id)) ::TVarChar AS idBarCode

                   , Object_ChoiceCell.isErased      AS isErased

              FROM Object AS Object_ChoiceCell
                   -- ��������� ������ � ������ "�����"
                   LEFT JOIN tmpPartionCell_RK ON tmpPartionCell_RK.GoodsId     = vbGoodsId
                                              AND tmpPartionCell_RK.GoodsKindId = vbGoodsKindId
                                              AND tmpPartionCell_RK.ord         = 1
                   -- ������ ������ � ������ ��������
                   LEFT JOIN tmpPartionCell_real ON tmpPartionCell_real.GoodsId     = vbGoodsId
                                                AND tmpPartionCell_real.GoodsKindId = vbGoodsKindId
                                                AND tmpPartionCell_real.ord         = 1

              WHERE Object_ChoiceCell.DescId = zc_Object_ChoiceCell()
                AND Object_ChoiceCell.Id     = vbChoiceCellId
             ) AS tmp
    ;

IF vbUserId = 5 AND 1=1
THEN
    RAISE EXCEPTION '������.OK (%)', vbGoodsId;
END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 24.08.24         *
*/

-- ����
--      "  201011041653    "  --SELECT * FROM gpSelect_Object_ChoiceCell (FALSE, zfCalc_UserAdmin())

