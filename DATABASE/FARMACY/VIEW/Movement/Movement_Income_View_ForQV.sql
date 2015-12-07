DROP VIEW IF EXISTS Movement_Income_View_ForQV;

CREATE OR REPLACE VIEW Movement_Income_View_ForQV AS 
    SELECT
        Movement.OperDate                                   AS OperDate
      , Movement.InvNumber                                  AS InvNumber
      , Object_From.ValueData                               AS FromName
      , ObjectHistoryString_JuridicalDetails_OKPO.ValueData AS OKPO
      , ObjectFloat_NDSKind_NDS.ValueData                   AS NDS
      , MovementFloat_TotalSummMVAT.ValueData               AS TotalSummMVAT
      , Link_Juridical.IntegerKey                           AS Juridical_QVCode
      , Link_Unit.IntegerKey                                AS Unit_QVCode
    FROM Movement 
        LEFT JOIN MovementFloat AS MovementFloat_TotalSummMVAT
                                ON MovementFloat_TotalSummMVAT.MovementId =  Movement.Id
                               AND MovementFloat_TotalSummMVAT.DescId = zc_MovementFloat_TotalSummMVAT()
        LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                     ON MovementLinkObject_From.MovementId = Movement.Id
                                    AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
        LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId
        
        LEFT JOIN MovementLinkObject AS MovementLinkObject_NDSKind
                                     ON MovementLinkObject_NDSKind.MovementId = Movement.Id
                                    AND MovementLinkObject_NDSKind.DescId = zc_MovementLinkObject_NDSKind()
        LEFT JOIN Object AS Object_NDSKind ON Object_NDSKind.Id = MovementLinkObject_NDSKind.ObjectId
        LEFT JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                              ON ObjectFloat_NDSKind_NDS.ObjectId = MovementLinkObject_NDSKind.ObjectId
                             AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()   
        LEFT OUTER JOIN ObjectHistory AS ObjectHistory_Juridical
                                      ON ObjectHistory_Juridical.ObjectId = MovementLinkObject_From.ObjectId
                                     AND ObjectHistory_Juridical.DescId = zc_ObjectHistory_JuridicalDetails()
                                     AND Movement.OperDate >= ObjectHistory_Juridical.StartDate AND Movement.OperDate < ObjectHistory_Juridical.EndDate
        LEFT JOIN ObjectHistoryString AS ObjectHistoryString_JuridicalDetails_OKPO
                                      ON ObjectHistoryString_JuridicalDetails_OKPO.ObjectHistoryId = ObjectHistory_Juridical.Id
                                     AND ObjectHistoryString_JuridicalDetails_OKPO.DescId = zc_ObjectHistoryString_JuridicalDetails_OKPO()
        LEFT OUTER JOIN MovementLinkObject AS Movement_Juridical
                                           ON Movement_Juridical.MovementId = Movement.Id
                                          AND Movement_Juridical.DescId = zc_MovementLinkObject_Juridical()
        LEFT OUTER JOIN MovementLinkObject AS Movement_To
                                           ON Movement_To.MovementId = Movement.Id
                                          AND Movement_To.DescId = zc_MovementLinkObject_To()
        LEFT OUTER JOIN ObjectLink AS Unit_Juridical
                                   ON Unit_Juridical.ObjectId = Movement_To.ObjectId
                                  AND Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
        LEFT OUTER JOIN Object_ImportExportLink_View AS Link_Juridical
                                                     ON Link_Juridical.MainId = COALESCE(Movement_Juridical.ObjectId,Unit_Juridical.ChildObjectId)
                                                    AND Link_Juridical.LinkTypeId = zc_Enum_ImportExportLinkType_QlikView()
        LEFT OUTER JOIN Object_ImportExportLink_View AS Link_Unit
                                                     ON Link_Unit.MainId = Movement_To.ObjectId
                                                    AND Link_Unit.LinkTypeId = zc_Enum_ImportExportLinkType_QlikView()
    WHERE 
        Movement.DescId = zc_Movement_Income()
        AND
        Movement.StatusId = zc_Enum_Status_Complete();

ALTER TABLE Movement_Income_View_ForQV
  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ÈÑÒÎÐÈß ÐÀÇÐÀÁÎÒÊÈ: ÄÀÒÀ, ÀÂÒÎÐ
               Ôåëîíþê È.Â.   Êóõòèí È.Â.   Êëèìåíòüåâ Ê.È.  Âîðîáêàëî À.À.
 05.12.15                                                         *
*/

-- òåñò
-- SELECT * FROM Movement_Income_View_ForQV where OperDate >= '20151201' AND Juridical_QVCode = 1
