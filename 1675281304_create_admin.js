migrate(
    (db) => {
        const admin = new Admin();
        admin.email = "PB_ADMIN_EMAIL";
        admin.setPassword("PB_ADMIN_PASSWORD");
        return Dao(db).saveAdmin(admin);
    },
    (db) => {}
);
