Create view mart.ventasdiarias_view AS
	Select *
		from core.fac_ventasdiarias
		LEFT JOIN CORE.dim_producto on ved_producto = pro_producto
		lEFT JOIN CORE.dim_vended on ven_vended = ved_vended