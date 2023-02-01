migrate(
    (db) => {
        const admin = new Admin();
        admin.email = "ADMIN_EMAIL";
        admin.setPassword("ADMIN_PASSWORD");
        return Dao(db).saveAdmin(admin);
    },
    (db) => {}
);
