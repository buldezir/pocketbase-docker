migrate(
    (db) => {
        if (process.env.PB_ADMIN_EMAIL && process.env.PB_ADMIN_PASSWORD) {
            const admin = new Admin();
            admin.email = process.env.PB_ADMIN_EMAIL;
            admin.setPassword(process.env.PB_ADMIN_PASSWORD);
            return Dao(db).saveAdmin(admin);
        }
    },
    (db) => {}
);
