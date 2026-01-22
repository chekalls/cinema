package mg.gestion.cinema.models;

import java.sql.Connection;

import mg.gestion.cinema.annotation.Column;
import mg.gestion.cinema.annotation.Loader;
import mg.gestion.cinema.annotation.PrimaryKey;
import mg.gestion.cinema.annotation.Table;
import mg.gestion.cinema.utils.CGenericUtils;

@Table(name = "type_place_prix")
public class TypePlacePrix extends BaseEntity {
    @PrimaryKey
    private Integer id;
    @Column(name = "prix_place")
    private double prixPlace;
    @Column(name = "type_place_id")
    private Integer typePlaceId;
    @Column(name = "type_personne_id")
    private Integer typePersonneId;

    @Column(name = "parent_id")
    private Integer parentId;

    @Column(name = "reduction")
    private Double reduction;

    @Column(ignore = true)
    private TypePlace typePlace;

    @Column(ignore = true)
    private TypePersone typePersone;

    @Column(ignore = true)
    private TypePlacePrix parent;

    @Loader
    public void loadAttribute(Connection conn) {
        if (this.getTypePlaceId() != null) {
            this.typePlace = CGenericUtils.findOne(conn, TypePlace.class, java.util.Map.of("id", this.getTypePlaceId()),
                    true);
        }
        if (this.typePersonneId != null) {
            this.typePersone = CGenericUtils.findOne(conn, TypePersone.class,
                    java.util.Map.of("id", this.getTypePersonneId()), true);
        }
        if (this.parentId != null) {
            this.parent = CGenericUtils.findOne(conn, TypePlacePrix.class,
                    java.util.Map.of("id", this.getParentId()), true);
        }
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public double getPrixPlace() {
        return prixPlace;
    }

    public void setPrixPlace(double prixPlace) {
        this.prixPlace = prixPlace;
    }

    public Integer getTypePlaceId() {
        return typePlaceId;
    }

    public void setTypePlaceId(Integer typePlaceId) {
        this.typePlaceId = typePlaceId;
    }

    public Integer getTypePersonneId() {
        return typePersonneId;
    }

    public void setTypePersonneId(Integer typePersonneId) {
        this.typePersonneId = typePersonneId;
    }

    public Integer getParentId() {
        return parentId;
    }

    public void setParentId(Integer parentId) {
        this.parentId = parentId;
    }

    public Double getReduction() {
        return reduction;
    }

    public void setReduction(Double reduction) {
        this.reduction = reduction;
    }

    public TypePlace getTypePlace() {
        return typePlace;
    }

    public void setTypePlace(TypePlace typePlace) {
        this.typePlace = typePlace;
    }

    public TypePersone getTypePersone() {
        return typePersone;
    }

    public void setTypePersone(TypePersone typePersone) {
        this.typePersone = typePersone;
    }

    public TypePlacePrix getParent() {
        return parent;
    }

    public void setParent(TypePlacePrix parent) {
        this.parent = parent;
    }

    /**
     * Calcule le prix final en tenant compte du parent et de la réduction
     * Si c'est un tarif dérivé (avec parent), utilise le prix du parent
     * Sinon utilise le prix de base
     */
    public double getPrixFinal() {
        double prixBase;
        
        // Si c'est un tarif dérivé avec un parent chargé, utiliser le prix du parent
        if (this.parent != null) {
            prixBase = this.parent.getPrixPlace();
        } else {
            // Sinon utiliser le prix de base de ce tarif
            prixBase = this.prixPlace;
        }
        
        // Appliquer la réduction si elle existe
        if (this.reduction != null && this.reduction > 0) {
            return prixBase - (prixBase * this.reduction / 100);
        }
        
        return prixBase;
    }
}
