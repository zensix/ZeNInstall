# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130720192509) do

  create_table "architectures", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "categories", :force => true do |t|
    t.string   "name",       :limit => 100, :null => false
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
    t.index ["name"], :name => "index_categories_on_name", :unique => true
  end

  create_table "countries", :force => true do |t|
    t.string   "code",       :limit => 10,  :null => false
    t.string   "name",       :limit => 100, :null => false
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
    t.index ["name"], :name => "index_countries_on_name", :unique => true
    t.index ["code"], :name => "index_countries_on_code", :unique => true
  end

  create_table "customers", :force => true do |t|
    t.string   "company_name",       :limit => 100, :null => false
    t.string   "contact_title",      :limit => 50
    t.string   "contact_first_name", :limit => 50
    t.string   "contact_last_name",  :limit => 50
    t.integer  "category_id",                       :null => false
    t.text     "address"
    t.string   "city",               :limit => 50
    t.string   "region",             :limit => 50
    t.integer  "postal_code",        :limit => 50
    t.integer  "country_id",                        :null => false
    t.string   "phone",              :limit => 50
    t.string   "fax",                :limit => 50
    t.string   "mobile",             :limit => 50
    t.string   "email",              :limit => 50
    t.string   "homepage",           :limit => 50
    t.string   "skype",              :limit => 50
    t.text     "notes"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.index ["country_id"], :name => "index_customers_on_country_id"
    t.index ["category_id"], :name => "index_customers_on_category_id"
    t.index ["company_name"], :name => "index_customers_on_company_name", :unique => true
    t.foreign_key ["category_id"], "categories", ["id"], :on_update => :cascade, :on_delete => :restrict
    t.foreign_key ["country_id"], "countries", ["id"], :on_update => :cascade, :on_delete => :restrict
  end

  create_table "etats", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "familles", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "script"
  end

  create_table "globalparameters", :force => true do |t|
    t.string   "name"
    t.string   "value"
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "ipxescripts", :force => true do |t|
    t.string   "name"
    t.text     "script"
    t.text     "description"
    t.integer  "famille_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.index ["famille_id"], :name => "index_ipxescripts_on_famille_id"
    t.foreign_key ["famille_id"], "familles", ["id"], :on_update => :no_action, :on_delete => :no_action
  end

  create_table "logs", :force => true do |t|
    t.datetime "date"
    t.string   "crit"
    t.string   "message"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "postinstallscripts", :force => true do |t|
    t.string   "name"
    t.text     "script"
    t.text     "description"
    t.integer  "famille_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.index ["famille_id"], :name => "index_postinstallscripts_on_famille_id"
    t.foreign_key ["famille_id"], "familles", ["id"], :on_update => :no_action, :on_delete => :no_action
  end

  create_table "projectionscripts", :force => true do |t|
    t.string   "name"
    t.text     "script"
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "sites", :force => true do |t|
    t.string   "name"
    t.string   "dnssrv"
    t.string   "dnsdomain"
    t.string   "netmask"
    t.string   "gateway"
    t.string   "puppetsrv"
    t.string   "proxyurl"
    t.string   "ntpsrv"
    t.text     "description"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "snmpcommunity"
  end

  create_table "systeminstallscripts", :force => true do |t|
    t.string   "name"
    t.text     "script"
    t.text     "description"
    t.integer  "famille_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.index ["famille_id"], :name => "index_systeminstallscripts_on_famille_id"
    t.foreign_key ["famille_id"], "familles", ["id"], :on_update => :no_action, :on_delete => :no_action
  end

  create_table "systems", :force => true do |t|
    t.string   "name"
    t.integer  "architecture_id"
    t.integer  "famille_id"
    t.string   "kernelpath"
    t.string   "initrdpath"
    t.string   "repository"
    t.integer  "ipxescript_id"
    t.text     "description"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.index ["ipxescript_id"], :name => "index_systems_on_ipxescript_id"
    t.index ["famille_id"], :name => "index_systems_on_famille_id"
    t.index ["architecture_id"], :name => "index_systems_on_architecture_id"
    t.foreign_key ["architecture_id"], "architectures", ["id"], :on_update => :no_action, :on_delete => :no_action
    t.foreign_key ["famille_id"], "familles", ["id"], :on_update => :no_action, :on_delete => :no_action
    t.foreign_key ["ipxescript_id"], "ipxescripts", ["id"], :on_update => :no_action, :on_delete => :no_action
  end

  create_table "servers", :force => true do |t|
    t.string   "name"
    t.string   "uuid"
    t.string   "mac"
    t.integer  "architecture_id"
    t.integer  "site_id"
    t.integer  "sitedestination"
    t.integer  "etat_id"
    t.integer  "system_id"
    t.integer  "postinstallscript_id"
    t.integer  "systeminstallscript_id"
    t.boolean  "usedhcp"
    t.boolean  "useproxy"
    t.string   "currentaddress"
    t.string   "destinationaddress"
    t.text     "information"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.text     "lastgeneratedpostinstallsctipt"
    t.text     "lastgeneratedinstallscript"
    t.boolean  "configlock"
    t.index ["systeminstallscript_id"], :name => "index_servers_on_systeminstallscript_id"
    t.index ["postinstallscript_id"], :name => "index_servers_on_postinstallscript_id"
    t.index ["system_id"], :name => "index_servers_on_system_id"
    t.index ["etat_id"], :name => "index_servers_on_etat_id"
    t.index ["site_id"], :name => "index_servers_on_site_id"
    t.index ["architecture_id"], :name => "index_servers_on_architecture_id"
    t.foreign_key ["architecture_id"], "architectures", ["id"], :on_update => :no_action, :on_delete => :no_action
    t.foreign_key ["site_id"], "sites", ["id"], :on_update => :no_action, :on_delete => :no_action
    t.foreign_key ["etat_id"], "etats", ["id"], :on_update => :no_action, :on_delete => :no_action
    t.foreign_key ["system_id"], "systems", ["id"], :on_update => :no_action, :on_delete => :no_action
    t.foreign_key ["postinstallscript_id"], "postinstallscripts", ["id"], :on_update => :no_action, :on_delete => :no_action
    t.foreign_key ["systeminstallscript_id"], "systeminstallscripts", ["id"], :on_update => :no_action, :on_delete => :no_action
  end

end
