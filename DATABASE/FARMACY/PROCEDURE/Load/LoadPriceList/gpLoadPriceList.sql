-- Function: gpInsertUpdate_Movement_BankAccount()

DROP FUNCTION IF EXISTS gpLoadPriceList (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpLoadPriceList(
    IN inId                  Integer   , -- �����-����
    IN inSession             TVarChar    -- ������ ������������
)                              
RETURNS Void AS
$BODY$
   DECLARE vbUserId       Integer;

   DECLARE vbMovementId_pl Integer;
   DECLARE vbJuridicalId   Integer;
   DECLARE vbContractId    Integer;
   DECLARE vbAreaId        Integer;
   DECLARE vbAreaId_find   Integer;
   DECLARE vbOperDate      TDateTime;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_LoadSaleFrom1C());
     vbUserId := lpGetUserBySession (inSession);

     -- �������� ��������� ����������
     SELECT LoadPriceList.OperDate	 
          , LoadPriceList.JuridicalId 
          , COALESCE (LoadPriceList.ContractId, 0)
          , COALESCE (LoadPriceList.AreaId, 0)
            INTO vbOperDate, vbJuridicalId, vbContractId, vbAreaId
      FROM LoadPriceList WHERE LoadPriceList.Id = inId;

     UPDATE LoadPriceList SET isMoved = true, UserId_Update = vbUserId, Date_Update = CURRENT_TIMESTAMP WHERE Id = inId;

     -- ���� ����� �� ���� ����, ������ � �������� �� ������, �� ���������. � ���� ������, �� ��������� ��
     SELECT
            Movement.Id INTO vbMovementId_pl
       FROM Movement 
            JOIN MovementLinkObject AS MovementLinkObject_Juridical
                                    ON MovementLinkObject_Juridical.MovementId = Movement.Id
                                   AND MovementLinkObject_Juridical.DescId = zc_MovementLinkObject_Juridical()
            JOIN MovementLinkObject AS MovementLinkObject_Contract
                                    ON MovementLinkObject_Contract.MovementId = Movement.Id
                                   AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
            LEFT JOIN MovementLinkObject AS MovementLinkObject_Area
                                         ON MovementLinkObject_Area.MovementId = Movement.Id
                                        AND MovementLinkObject_Area.DescId     = zc_MovementLinkObject_Area()
      WHERE Movement.OperDate = vbOperDate AND Movement.DescId = zc_Movement_PriceList()
        AND MovementLinkObject_Juridical.ObjectId = vbJuridicalId 
        AND COALESCE (MovementLinkObject_Contract.ObjectId, 0) = vbContractId
        AND COALESCE (MovementLinkObject_Area.ObjectId, 0)     = vbAreaId
       ;

      IF COALESCE (vbMovementId_pl, 0) = 0 THEN 
         vbMovementId_pl := gpInsertUpdate_Movement_PriceList (0, '', vbOperDate, vbJuridicalId, vbContractId, vbAreaId, inSession);
      END IF;

      -- ���������� ������ ��� ������ ������
      vbAreaId_find := COALESCE ( (SELECT ObjectLink_JuridicalArea_Area.ChildObjectId AS AreaId
                                   FROM ObjectLink AS ObjectLink_JuridicalArea_Juridical
                                        INNER JOIN Object AS Object_JuridicalArea ON Object_JuridicalArea.Id       = ObjectLink_JuridicalArea_Juridical.ObjectId
                                                                                 AND Object_JuridicalArea.isErased = FALSE
                                        INNER JOIN ObjectLink AS ObjectLink_JuridicalArea_Area
                                                              ON ObjectLink_JuridicalArea_Area.ObjectId      = Object_JuridicalArea.Id
                                                             AND ObjectLink_JuridicalArea_Area.DescId        = zc_ObjectLink_JuridicalArea_Area()
                                        -- ���������� ��� ���������� ������ ��� �������
                                        INNER JOIN ObjectBoolean AS ObjectBoolean_JuridicalArea_GoodsCode
                                                                 ON ObjectBoolean_JuridicalArea_GoodsCode.ObjectId  = Object_JuridicalArea.Id
                                                                AND ObjectBoolean_JuridicalArea_GoodsCode.DescId    = zc_ObjectBoolean_JuridicalArea_GoodsCode()
                                                                AND ObjectBoolean_JuridicalArea_GoodsCode.ValueData = TRUE
                                   WHERE ObjectLink_JuridicalArea_Juridical.DescId        = zc_ObjectLink_JuridicalArea_Juridical()
                                     AND ObjectLink_JuridicalArea_Juridical.ChildObjectId = vbJuridicalId
                                     AND ObjectLink_JuridicalArea_Area.ChildObjectId      = vbAreaId
                                  ) , 0);

     -- ��������� ��������� ���� ������ � ������������� 
     PERFORM CASE WHEN COALESCE (ObjectDate_LastPriceOLd.ValueData, NULL) <> NULL
                  THEN CASE WHEN COALESCE (ObjectDate_LastPrice.ValueData, NULL) <> NULL AND ObjectDate_LastPrice.ValueData > ObjectDate_LastPriceOLd.ValueData
                            THEN lpInsertUpdate_ObjectDate (zc_ObjectDate_Goods_LastPriceOld(), GoodsId, ObjectDate_LastPrice.ValueData)              
                       END
                  ELSE lpInsertUpdate_ObjectDate (zc_ObjectDate_Goods_LastPriceOld(), GoodsId, ObjectDate_LastPrice.ValueData) 
             END,
             CASE WHEN COALESCE (ObjectDate_LastPriceOLd.ValueData, NULL) <> NULL
                  THEN CASE WHEN COALESCE (ObjectDate_LastPrice.ValueData, NULL) <> NULL AND ObjectDate_LastPrice.ValueData > ObjectDate_LastPriceOLd.ValueData
                            THEN lpUpdate_Goods_LastPriceOld (GoodsId, ObjectDate_LastPrice.ValueData, vbUserId)              
                       END
                  ELSE lpUpdate_Goods_LastPriceOld (GoodsId, ObjectDate_LastPrice.ValueData, vbUserId) 
             END 
        
      FROM LoadPriceListItem 
           JOIN LoadPriceList ON LoadPriceList.Id = LoadPriceListItem.LoadPriceListId
              
           LEFT JOIN ObjectDate AS ObjectDate_LastPrice
                                ON ObjectDate_LastPrice.ObjectId = LoadPriceListItem.GoodsId
                               AND ObjectDate_LastPrice.DescId = zc_ObjectDate_Goods_LastPrice()
           LEFT JOIN ObjectDate AS ObjectDate_LastPriceOld
                                ON ObjectDate_LastPriceOld.ObjectId = LoadPriceListItem.GoodsId
                               AND ObjectDate_LastPriceOld.DescId = zc_ObjectDate_Goods_LastPriceOld()
      WHERE GoodsId <> 0 AND LoadPriceListId = inId;
      
     -- ���������� ���� ����� ������� ������
     UPDATE MovementItem SET isErased = FALSE 
     WHERE MovementItem.MovementId = vbMovementId_pl 
       AND MovementItem.isErased = TRUE;
     
      
     -- ������� ��������� ������
     PERFORM 
         lpInsertUpdate_MovementItem_PriceList (tmp.MovementItemId , -- ���� ������� <������� ���������>
                                                   vbMovementId_pl , -- ���� ������� <��������>
                                                       tmp.GoodsId , -- inGoodsMainId - ������
                                                  tmp.GoodsId_find , -- inGoodsId     - ����� �����-�����
                                           
                                                      CASE WHEN tmp.NDSinPrice = TRUE
                                                                THEN tmp.Price 
                                                           ELSE tmp.Price * (100 + tmp.NDS) / 100 
                                                      END:: TFloat  , -- ����
                                            
                                                      CASE WHEN tmp.NDSinPrice = TRUE
                                                                THEN tmp.PriceOriginal 
                                                           ELSE tmp.PriceOriginal * (100 + tmp.NDS) / 100
                                                      END :: TFloat , -- !!!���� ������������!!!
                                           
                                                 tmp.ExpirationDate , -- ������ ������
                                                        tmp.Remains , -- �������
                                                           vbUserId)
        , lpInsertUpdate_ObjectDate (zc_ObjectDate_Goods_LastPrice(), tmp.GoodsId, vbOperDate)              -- ���� ������ --CURRENT_TIMESTAMP
        , lpUpdate_Goods_LastPrice (tmp.GoodsId, vbOperDate, vbUserId)
          -- ���-�� ������� �� ���� �������
        --, lpInsertUpdate_Goods_CountPrice (vbMovementId_pl, vbOperDate, tmp.GoodsId)

       FROM (WITH tmpGoods AS (SELECT Object_Goods_View.Id, Object_Goods_View.GoodsCode
                               FROM Object_Goods_View
                               WHERE Object_Goods_View.ObjectId = vbJuridicalId
                                 AND (-- ���� ������ ������������
                                      COALESCE (Object_Goods_View.AreaId, 0) = vbAreaId_find
                                      -- ��� ��� ������ zc_Area_Basis - ����� ���� � ������� "�����"
                                   OR (vbAreaId_find = zc_Area_Basis() AND Object_Goods_View.AreaId IS NULL)
                                      -- ��� ��� ������ "�����" - ����� ���� � ������� zc_Area_Basis
                                   OR (vbAreaId_find = 0 AND Object_Goods_View.AreaId = zc_Area_Basis())
                                     )
                              )
             SELECT LoadPriceListItem.*
                  , LoadPriceList.NDSinPrice
                  , MovementItem.Id AS MovementItemId
                  , tmpGoods.Id     AS GoodsId_find
                  , ObjectFloat_NDSKind_NDS.ValueData AS NDS
             FROM LoadPriceListItem 
                  JOIN LoadPriceList ON LoadPriceList.Id = LoadPriceListItem.LoadPriceListId
                  LEFT JOIN ObjectLink AS ObjectLink_Goods_NDSKind
                                       ON ObjectLink_Goods_NDSKind.ObjectId = LoadPriceListItem.GoodsId
                                      AND ObjectLink_Goods_NDSKind.DescId = zc_ObjectLink_Goods_NDSKind()
                     
                  LEFT JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                                        ON ObjectFloat_NDSKind_NDS.ObjectId = ObjectLink_Goods_NDSKind.Childobjectid
                                       AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()   
      
                  INNER JOIN tmpGoods ON tmpGoods.goodscode = LoadPriceListItem.GoodsCode
                          
                  LEFT JOIN MovementItem ON MovementItem.ObjectId = LoadPriceListItem.GoodsId AND MovementItem.MovementId = vbMovementId_pl
                  /*LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods
                                                   ON MILinkObject_Goods.MovementItemId = MovementItem.Id
                                                  AND MILinkObject_Goods.DescId         = zc_MILinkObject_Goods()
                                                  AND MILinkObject_Goods.ObjectId       = tmpGoods.Id*/
                    
                    
             WHERE LoadPriceListItem.GoodsId > 0 AND LoadPriceListItem.LoadPriceListId = inId
            ) AS tmp;

     -- ������ ���� ����� ���� �� ������
     UPDATE MovementItem SET isErased = TRUE
     WHERE MovementItem.MovementId = vbMovementId_pl
       AND MovementItem.ID NOT IN (SELECT  MovementItem.Id AS MovementItemId
                                   FROM LoadPriceListItem 
                                        JOIN LoadPriceList ON LoadPriceList.Id = LoadPriceListItem.LoadPriceListId      
                                        LEFT JOIN MovementItem ON MovementItem.ObjectId = LoadPriceListItem.GoodsId AND MovementItem.MovementId = vbMovementId_pl
                                   WHERE LoadPriceListItem.GoodsId > 0 AND LoadPriceListItem.LoadPriceListId = inId);
                   
     -- ��������� ��������
     -- PERFORM lpInsert_MovementProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.   ������ �.�.
 22.10.19                                                                   *
 18.08.17         *
 21.04.17         *
 28.01.15                        *  ������ ���� � ������ ��������� ������
 26.10.14                        *  
 18.09.14                        *  
 10.09.14                        *  
*/

-- ����
-- SELECT * FROM gpLoadSaleFrom1C('01-01-2013'::TDateTime, '01-01-2014'::TDateTime, '')
-- lpInsertUpdate_ObjectDate (zc_ObjectDate_Goods_LastPrice(), GoodsId, vbOperDate) 