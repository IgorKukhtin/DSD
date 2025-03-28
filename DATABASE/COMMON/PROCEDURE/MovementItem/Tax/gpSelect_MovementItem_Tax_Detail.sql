-- Function: gpSelect_MovementItem_Tax_Detail()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_Tax_Detail (Integer, Boolean,  TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_Tax_Detail(
    IN inMovementId  Integer      , -- ���� ���������
    IN inisErased    Boolean      , --
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer
             , ContractId Integer, ContractCode Integer, ContractName TVarChar
             , ContractTagName TVarChar, ContractKindName TVarChar, StartDate TDateTime, EndDate TDateTime
             , isErased Boolean
              )
AS
$BODY$
  DECLARE vbJuridicalId  Integer;
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Tax());

     -- inShowAll:= TRUE;
  
/*     IF inShowAll = TRUE THEN

     RETURN QUERY
       WITH
       tmpContract AS ( SELECT ObjectLink_Contract_Juridical.ObjectId AS ContractId
                                     FROM ObjectLink AS ObjectLink_Contract_Juridical
                                          
                                          INNER JOIN Object AS Object_Contract ON Object_Contract.Id = ObjectLink_Contract_Juridical.ObjectId
                                                           AND Object_Contract.isErased = FALSE
                                                               
                                     WHERE ObjectLink_Contract_Juridical.ChildObjectId = vbJuridicalId --3931441 --
                                       AND ObjectLink_Contract_Juridical.DescId = zc_ObjectLink_Contract_Juridical()
                       )
     , tmpMI AS (SELECT MovementItem.*
                 FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                      JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                       AND MovementItem.DescId     = zc_MI_Detail()
                                       AND MovementItem.isErased   = tmpIsErased.isErased) 
                )


       SELECT
             0                             AS Id
           , Object_Contract.Id            AS ContractId
           , Object_Contract.ObjectCode    AS ContractCode
           , Object_Contract.ValueData     AS ContractName
           , FALSE                         AS isErased

       FROM tmpContract
            LEFT JOIN tmpMI ON tmpMI.ObjectId = tmpContract.ContractId
            LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = tmpContract.ContractId
       WHERE tmpMI.ObjectId IS NULL
      UNION ALL
       SELECT
             MovementItem.Id               AS Id
           , Object_Contract.Id            AS ContractId
           , Object_Contract.ObjectCode    AS ContractCode
           , Object_Contract.ValueData     AS ContractName
           , MovementItem.isErased         AS isErased

       FROM tmpMI AS MovementItem ON MovementItem.MovementId = inMovementId
            LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = MovementItem.ObjectId
            ;
     ELSE
*/

     RETURN QUERY
       SELECT
            MovementItem.Id               AS Id
           , Object_Contract.Id            AS ContractId
           , Object_Contract.ObjectCode    AS ContractCode
           , Object_Contract.ValueData     AS ContractName
           
           , Object_ContractTag.ValueData  AS ContractTagName
           , Object_ContractKind.ValueData AS ContractKindName
           , ObjectDate_Start.ValueData    AS StartDate
           , ObjectDate_End.ValueData      AS EndDate

           , MovementItem.isErased         AS isErased
       FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
            JOIN MovementItem ON MovementItem.MovementId = inMovementId
                             AND MovementItem.DescId     = zc_MI_Detail()
                             AND MovementItem.isErased   = tmpIsErased.isErased
            LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = MovementItem.ObjectId 

            LEFT JOIN ObjectDate AS ObjectDate_Start
                                 ON ObjectDate_Start.ObjectId = Object_Contract.Id
                                AND ObjectDate_Start.DescId = zc_ObjectDate_Contract_Start()
                                AND Object_Contract.ValueData <> '-'
            LEFT JOIN ObjectDate AS ObjectDate_End
                                 ON ObjectDate_End.ObjectId = Object_Contract.Id
                                AND ObjectDate_End.DescId = zc_ObjectDate_Contract_End()
                                AND Object_Contract.ValueData <> '-'

            LEFT JOIN ObjectLink AS ObjectLink_Contract_ContractTag
                                 ON ObjectLink_Contract_ContractTag.ObjectId = Object_Contract.Id
                                AND ObjectLink_Contract_ContractTag.DescId = zc_ObjectLink_Contract_ContractTag()
            LEFT JOIN Object AS Object_ContractTag ON Object_ContractTag.Id = ObjectLink_Contract_ContractTag.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Contract_ContractKind
                                 ON ObjectLink_Contract_ContractKind.ObjectId = Object_Contract.Id 
                                AND ObjectLink_Contract_ContractKind.DescId = zc_ObjectLink_Contract_ContractKind()
                                AND Object_Contract.ValueData <> '-'
            LEFT JOIN Object AS Object_ContractKind ON Object_ContractKind.Id = ObjectLink_Contract_ContractKind.ChildObjectId
       ;

   --  END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 29.04.24         *
*/

-- ����
--  SELECT * FROM gpSelect_MovementItem_Tax_Detail (inMovementId:= 4229, inisErased:= FALSE, inSession:= zfCalc_UserAdmin())
