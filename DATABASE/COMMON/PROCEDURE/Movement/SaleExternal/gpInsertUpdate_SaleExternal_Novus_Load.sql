-- Function: gpInsertUpdate_SaleExternal_Novus_Load()

DROP FUNCTION IF EXISTS gpInsertUpdate_SaleExternal_Novus_Load (TDateTime, Integer, TVarChar, TVarChar, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_SaleExternal_Novus_Load(
    IN inOperDate              TDateTime , --
    IN inRetailId              Integer   , --
    IN inPartnerExternalName   TVarChar  , -- 
    IN inGoodsName             TVarChar  , -- 
    IN inAmount                TFloat    , -- ����������
    IN inAmount_kg             TFloat    , -- ���
    IN inSession               TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId            Integer;
   DECLARE vbPartnerExternalCode TVarChar;
   DECLARE vbPartnerExternalId Integer;
   DECLARE vbGoodsPropertyId   Integer;
   DECLARE vbGoodsPropertyValueId Integer;
   DECLARE vbGoodsId           Integer;
   DECLARE vbGoodsKindId       Integer;
   DECLARE vbMovementId        Integer;
   DECLARE vbId                Integer;
   DECLARE vbArticle           TVarChar;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_SaleExternal());

     -- ��������
     IF COALESCE (inRetailId,0) = 0
     THEN
         RAISE EXCEPTION '������.�������� ���� �� �������';
     END IF;

     --�� �������� ������� ��� vbPartnerExternalCode
     vbPartnerExternalCode := (SELECT LEFT (inPartnerExternalName, POSITION('~' IN inPartnerExternalName)-1 ));
     --�������� �������� ��� ����
     inPartnerExternalName := (SELECT SUBSTRING (inPartnerExternalName , POSITION('~' IN inPartnerExternalName)+1, LENGTH (inPartnerExternalName) - POSITION('~' IN inPartnerExternalName) ) );
     
     --��� ������ ���� �������� ��� � �������� 
     vbArticle := (SELECT LEFT (inGoodsName, POSITION('~' IN inGoodsName)-1));
     inGoodsName := (SELECT SUBSTRING (inGoodsName , POSITION('~' IN inGoodsName)+1, LENGTH (inGoodsName) - POSITION('~' IN inGoodsName) ) );

     --���� PartnerExternal
     vbPartnerExternalId := (SELECT Object_PartnerExternal.Id 
                             FROM Object AS Object_PartnerExternal
                                  INNER JOIN ObjectString AS ObjectString_ObjectCode
                                                          ON ObjectString_ObjectCode.ObjectId = Object_PartnerExternal.Id 
                                                         AND ObjectString_ObjectCode.DescId = zc_ObjectString_PartnerExternal_ObjectCode()
                                                         AND ObjectString_ObjectCode.ValueData = vbPartnerExternalCode
                                  LEFT JOIN ObjectLink AS ObjectLink_Retail
                                                       ON ObjectLink_Retail.ObjectId = Object_PartnerExternal.Id 
                                                      AND ObjectLink_Retail.DescId = zc_ObjectLink_PartnerExternal_Retail()
                             WHERE Object_PartnerExternal.DescId = zc_Object_PartnerExternal()
                               AND (ObjectLink_Retail.ChildObjectId = inRetailId OR COALESCE(ObjectLink_Retail.ChildObjectId,0) = 0)
                             );
     
     --���� �� ������
     IF COALESCE (vbPartnerExternalId,0) = 0
     THEN
         RAISE EXCEPTION '������.���������� ������� - (<%>) <%> �� ������.', vbPartnerExternalCode, inPartnerExternalName;
         /*vbPartnerExternalId :=  lpInsertUpdate_Object_PartnerExternal (ioId         := 0
                                                                      , inCode       := lfGet_ObjectCode(0, zc_Object_PartnerExternal())
                                                                      , inName       := inPartnerExternalName
                                                                      , inObjectCode := vbPartnerExternalCode
                                                                      , inPartnerId  := 0 -- inPartnerId
                                                                      , inContractId := 0 -- inContractId
                                                                      , inRetailId   := inRetailId
                                                                      , inUserId     := vbUserId
                                                                      );
                                                                      */
     ELSE
         --���� ������� ������ ������������ ������ �������� ����. ����
         PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_PartnerExternal_Retail(), vbPartnerExternalId, inRetailId);
     END IF;

     --������� ������������� ������� �������, �� ����� � partner , ����� juridical, ����� GoodsProperty
     vbGoodsPropertyId := (SELECT ObjectLink_Juridical_GoodsProperty.ChildObjectId
                           FROM ObjectLink AS ObjectLink_Partner
                                LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                     ON ObjectLink_Partner_Juridical.ObjectId = ObjectLink_Partner.ChildObjectId
                                                    AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                                LEFT JOIN ObjectLink AS ObjectLink_Juridical_GoodsProperty
                                                     ON ObjectLink_Juridical_GoodsProperty.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                                                    AND ObjectLink_Juridical_GoodsProperty.DescId = zc_ObjectLink_Juridical_GoodsProperty()
                           WHERE ObjectLink_Partner.ObjectId = vbPartnerExternalId 
                             AND ObjectLink_Partner.DescId = zc_ObjectLink_PartnerExternal_Partner()
                           );

     -- ������� ����� �������� 
     vbMovementId := (SELECT Movement.Id
                      FROM Movement
                           INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                                        AND MovementLinkObject_From.ObjectId = vbPartnerExternalId
                           INNER JOIN MovementLinkObject AS MovementLinkObject_GoodsProperty
                                                         ON MovementLinkObject_GoodsProperty.MovementId = Movement.Id
                                                        AND MovementLinkObject_GoodsProperty.DescId = zc_MovementLinkObject_GoodsProperty()
                                                        AND MovementLinkObject_GoodsProperty.ObjectId = vbGoodsPropertyId
                      WHERE Movement.DescId = zc_Movement_SaleExternal()
                        AND Movement.StatusId = zc_Enum_Status_UnComplete()
                        AND Movement.OperDate =  DATE_TRUNC ('MONTH', inOperDate)
                      );

     -- ���� �� ����� �������
     IF COALESCE (vbMovementId,0) = 0
     THEN
         -- ��������� <��������>
         vbMovementId:= lpInsertUpdate_Movement_SaleExternal (ioId               := 0
                                                            , inInvNumber        := CAST (NEXTVAL ('movement_SaleExternal_seq') AS TVarChar)
                                                            , inOperDate         := inOperDate
                                                            , inFromId           := vbPartnerExternalId
                                                            , inGoodsPropertyId  := vbGoodsPropertyId
                                                            , inComment          := '��������' :: TVarChar
                                                            , inUserId           := vbUserId
                                                             )AS tmp;
     END IF;

     --������� ������
     --������� GoodsId �� ��������
     SELECT ObjectLink_GoodsPropertyValue_Goods.ChildObjectId     AS GoodsId
          , ObjectLink_GoodsPropertyValue_GoodsKind.ChildObjectId AS GoodsKindId
          , ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId  AS GoodsPropertyValueId
   INTO vbGoodsId, vbGoodsKindId, vbGoodsPropertyValueId
     FROM ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsProperty
          INNER JOIN ObjectString AS ObjectString_Article
                                  ON ObjectString_Article.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                 AND ObjectString_Article.DescId = zc_ObjectString_GoodsPropertyValue_Article()
                                 AND ObjectString_Article.ValueData = vbArticle
          INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_Goods
                                ON ObjectLink_GoodsPropertyValue_Goods.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                               AND ObjectLink_GoodsPropertyValue_Goods.DescId = zc_ObjectLink_GoodsPropertyValue_Goods()
          INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsKind
                               ON ObjectLink_GoodsPropertyValue_GoodsKind.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                              AND ObjectLink_GoodsPropertyValue_GoodsKind.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsKind()
     WHERE ObjectLink_GoodsPropertyValue_GoodsProperty.ChildObjectId = vbGoodsPropertyId
       AND ObjectLink_GoodsPropertyValue_GoodsProperty.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsProperty()
     ;

     -- ��������� ��-��  zc_ObjectString_GoodsPropertyValue_NameExternal
     PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_GoodsPropertyValue_NameExternal(), vbGoodsPropertyValueId, inGoodsName);

     -- ����� ���� ����� ����� ��� �������
     vbId := (SELECT MovementItem.Id
              FROM MovementItem
                   INNER JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                     ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                    AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                                                    AND MILinkObject_GoodsKind.ObjectId = vbGoodsKindId
              WHERE MovementItem.MovementId = vbMovementId
                AND MovementItem.DescId = zc_MI_Master()
                AND MovementItem.isErased = FALSE
                AND MovementItem.ObjectId = vbGoodsId
              LIMIT 1
             );

     -- ��������� <������� ���������>
     PERFORM lpInsertUpdate_MovementItem_SaleExternal (ioId           := COALESCE (vbId,0) ::Integer
                                                     , inMovementId   := vbMovementId      ::Integer
                                                     , inGoodsId      := vbGoodsId         ::Integer
                                                     , inAmount       := CASE WHEN ObjectLink_Measure.ChildObjectId = zc_Measure_Sh() THEN inAmount ELSE inAmount_kg END ::TFloat
                                                     , inGoodsKindId  := vbGoodsKindId     ::Integer
                                                     , inUserId       := vbUserId          ::Integer
                                                      ) 
     FROM ObjectLink AS ObjectLink_Measure
     WHERE ObjectLink_Measure.ObjectId = vbGoodsId
       AND ObjectLink_Measure.DescId = zc_ObjectLink_Goods_Measure();

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
01.11.20          *
*/

-- ����
--