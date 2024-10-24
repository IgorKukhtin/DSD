-- Function: gpSelect_Object_DiffKindCash(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_DiffKindCash(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_DiffKindCash(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , MaxOrderUnitAmount TFloat
             , MaxOrderAmount TFloat
             , MaxOrderAmountSecond TFloat
             , DaysForSale Integer
             , isLessYear Boolean
             , isFormOrder Boolean
             , isFindLeftovers Boolean
             , Packages TFloat
             ) 
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
   DECLARE vbNotCashListDiff Boolean;
   DECLARE vbParticipDistribListDiff Boolean;
   DECLARE vbPartnerMedicalId  Integer;
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_DiffKind());
   vbUserId:= lpGetUserBySession (inSession);
   vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
   IF vbUnitKey = '' THEN
      vbUnitKey := '0';
   END IF;
   vbUnitId := vbUnitKey::Integer;


   SELECT COALESCE (ObjectBoolean_NotCashListDiff.ValueData, FALSE)
        , COALESCE (ObjectBoolean_ParticipDistribListDiff.ValueData, FALSE)
        , COALESCE (ObjectLink_Unit_PartnerMedical.ChildObjectId, 0)
   INTO vbNotCashListDiff, vbParticipDistribListDiff, vbPartnerMedicalId
   FROM Object AS Object_Unit

        LEFT JOIN ObjectBoolean AS ObjectBoolean_ParticipDistribListDiff
                                ON ObjectBoolean_ParticipDistribListDiff.ObjectId = Object_Unit.Id
                               AND ObjectBoolean_ParticipDistribListDiff.DescId = zc_ObjectBoolean_Unit_ParticipDistribListDiff()

        LEFT JOIN ObjectBoolean AS ObjectBoolean_NotCashListDiff
                                ON ObjectBoolean_NotCashListDiff.ObjectId = Object_Unit.Id
                               AND ObjectBoolean_NotCashListDiff.DescId = zc_ObjectBoolean_Unit_NotCashListDiff()

        LEFT JOIN ObjectLink AS ObjectLink_Unit_PartnerMedical
                             ON ObjectLink_Unit_PartnerMedical.ObjectId = Object_Unit.Id
                            AND ObjectLink_Unit_PartnerMedical.DescId = zc_ObjectLink_Unit_PartnerMedical()

   WHERE Object_Unit.Id = vbUnitId;
     
   RETURN QUERY 
     SELECT Object_DiffKind.Id                                                   AS Id
          , Object_DiffKind.ObjectCode                                           AS Code
          , Object_DiffKind.ValueData                                            AS Name
          , CASE WHEN vbNotCashListDiff = TRUE 
                 THEN ObjectFloat_DiffKind_MaxOrderAmountSecond.ValueData 
                 ELSE ObjectFloat_DiffKind_MaxOrderAmount.ValueData END::TFloat  AS MaxOrderUnitAmount
          , ObjectFloat_DiffKind_MaxOrderAmount.ValueData                        AS MaxOrderAmount
          , ObjectFloat_DiffKind_MaxOrderAmountSecond.ValueData                  AS MaxOrderAmountSecond
          , 0 /*ObjectFloat_DiffKind_DaysForSale.ValueData::Integer*/            AS DaysForSale
          , COALESCE(ObjectBoolean_DiffKind_LessYear.ValueData, FALSE)           AS isLessYear
          , COALESCE(ObjectBoolean_DiffKind_FormOrder.ValueData, False)          AS isFormOrder            
          , COALESCE(ObjectBoolean_DiffKind_FindLeftovers.ValueData, False) AND 
            COALESCE(vbParticipDistribListDiff, False)                           AS isFindLeftovers           
          , ObjectFloat_DiffKind_Packages.ValueData                              AS Packages
     FROM Object AS Object_DiffKind
          LEFT JOIN ObjectFloat AS ObjectFloat_DiffKind_MaxOrderAmount
                                ON ObjectFloat_DiffKind_MaxOrderAmount.ObjectId = Object_DiffKind.Id 
                               AND ObjectFloat_DiffKind_MaxOrderAmount.DescId = zc_ObjectFloat_MaxOrderAmount() 
          LEFT JOIN ObjectFloat AS ObjectFloat_DiffKind_MaxOrderAmountSecond
                                ON ObjectFloat_DiffKind_MaxOrderAmountSecond.ObjectId = Object_DiffKind.Id 
                               AND ObjectFloat_DiffKind_MaxOrderAmountSecond.DescId = zc_ObjectFloat_MaxOrderAmountSecond() 
          LEFT JOIN ObjectFloat AS ObjectFloat_DiffKind_DaysForSale
                                ON ObjectFloat_DiffKind_DaysForSale.ObjectId = Object_DiffKind.Id 
                               AND ObjectFloat_DiffKind_DaysForSale.DescId = zc_ObjectFloat_DiffKind_DaysForSale() 
          LEFT JOIN ObjectBoolean AS ObjectBoolean_DiffKind_LessYear
                                  ON ObjectBoolean_DiffKind_LessYear.ObjectId = Object_DiffKind.Id
                                 AND ObjectBoolean_DiffKind_LessYear.DescId = zc_ObjectBoolean_DiffKind_LessYear()   
          LEFT JOIN ObjectBoolean AS ObjectBoolean_DiffKind_FormOrder
                                  ON ObjectBoolean_DiffKind_FormOrder.ObjectId = Object_DiffKind.Id
                                 AND ObjectBoolean_DiffKind_FormOrder.DescId = zc_ObjectBoolean_DiffKind_FormOrder()   
          LEFT JOIN ObjectBoolean AS ObjectBoolean_DiffKind_FindLeftovers
                                  ON ObjectBoolean_DiffKind_FindLeftovers.ObjectId = Object_DiffKind.Id
                                 AND ObjectBoolean_DiffKind_FindLeftovers.DescId = zc_ObjectBoolean_DiffKind_FindLeftovers()   
          LEFT JOIN ObjectFloat AS ObjectFloat_DiffKind_Packages
                                ON ObjectFloat_DiffKind_Packages.ObjectId = Object_DiffKind.Id 
                               AND ObjectFloat_DiffKind_Packages.DescId = zc_ObjectFloat_DiffKind_Packages() 
     WHERE Object_DiffKind.DescId = zc_Object_DiffKind()
       AND Object_DiffKind.isErased = FALSE
       AND (COALESCE (vbPartnerMedicalId, 0) <> 0 OR Object_DiffKind.ValueData NOT ILIKE '%1303%')
     ORDER BY Object_DiffKind.ValueData;
  
END;
$BODY$
 
LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 12.12.18                                                       *              

*/

-- ����
-- 
SELECT * FROM gpSelect_Object_DiffKindCash('3')