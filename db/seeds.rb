def check_and_update_folder(folder)

    tmpFolder = DmsfFolder.find_by({:dmsf_folder_id => folder[:dmsf_folder_id], :project_id => folder[:project_id], :title => folder[:title], :deleted => '0'})
    if (!tmpFolder)
        if (tmpFolder = DmsfFolder.create!(folder))
            return tmpFolder
        else
            return nil
        end
    else
        return tmpFolder
    end

end

def check_and_update_link(link)

    tmpLink = DmsfLink.find_by({:target_type => link[:target_type], :name => link[:name],
                                :target_project_id => link[:project_id], :target_id => link[:target_id],
                                :project_id => link[:project_id], :dmsf_folder_id => link[:dmsf_folder_id],
                                :deleted => '0'})
    if (!tmpLink)
        if (tmpLink = DmsfLink.create!(link))
            return tmpLink
        else
            return nil
        end
    else
        return tmpLink
    end

end

Project.find_each do |project|

    project_id = project.id
    admin_id = '1'

    hardwareData = {:dmsf_folder_id => nil, :project_id => project_id, :title => "硬件存档", :user_id => admin_id}
    softwareData = {:dmsf_folder_id => nil, :project_id => project_id, :title => "软件存档", :user_id => admin_id}
    processData = {:dmsf_folder_id => nil, :project_id => project_id, :title => "工艺存档", :user_id => admin_id}
    produceData = {:dmsf_folder_id => nil, :project_id => project_id, :title => "生产文件存档", :user_id => admin_id}

    if ((hardwareFolder = check_and_update_folder(hardwareData)))

        binFolder = check_and_update_folder({:dmsf_folder_id => hardwareFolder.id, :title => "BIN", :user_id => admin_id, :project_id => project_id});
        bomFolder = check_and_update_folder({:dmsf_folder_id => hardwareFolder.id, :title => "BOM", :user_id => admin_id, :project_id => project_id});

        check_and_update_folder({:dmsf_folder_id => hardwareFolder.id, :title => "CPLD", :user_id => admin_id, :project_id => project_id})
        check_and_update_folder({:dmsf_folder_id => hardwareFolder.id, :title => "DOC", :user_id => admin_id, :project_id => project_id})
        check_and_update_folder({:dmsf_folder_id => hardwareFolder.id, :title => "DXF", :user_id => admin_id, :project_id => project_id})

        if (pcbFolder = check_and_update_folder({:dmsf_folder_id => hardwareFolder.id, :title => "PCB", :user_id => admin_id, :project_id => project_id}))

            papFolder = check_and_update_folder({:dmsf_folder_id => pcbFolder.id, :title => "pick_and_place", :user_id => admin_id, :project_id => project_id})
            smtFolder = check_and_update_folder({:dmsf_folder_id => pcbFolder.id, :title => "smt_gerbers", :user_id => admin_id, :project_id => project_id})
            check_and_update_folder({:dmsf_folder_id => pcbFolder.id, :title => "pcb_layout", :user_id => admin_id, :project_id => project_id})
            check_and_update_folder({:dmsf_folder_id => pcbFolder.id, :title => "gerbers", :user_id => admin_id, :project_id => project_id})

        end

        check_and_update_folder({:dmsf_folder_id => hardwareFolder.id, :title => "SCH", :user_id => admin_id, :project_id => project_id})

    end

    if ((softwareFolder = check_and_update_folder(softwareData)))

            check_and_update_folder({:dmsf_folder_id => softwareFolder.id, :title => "src", :user_id => admin_id, :project_id => project_id})
            releaseFolder = check_and_update_folder({:dmsf_folder_id => softwareFolder.id, :title => "release", :user_id => admin_id, :project_id => project_id})
            check_and_update_folder({:dmsf_folder_id => softwareFolder.id, :title => "DOC", :user_id => admin_id, :project_id => project_id})

    end

    if ((processFolder = check_and_update_folder(processData)))

            check_and_update_folder({:dmsf_folder_id => processFolder.id, :title => "quality", :user_id => admin_id, :project_id => project_id})
            check_and_update_folder({:dmsf_folder_id => processFolder.id, :title => "test", :user_id => admin_id, :project_id => project_id})

    end

    if ((produceFolder = check_and_update_folder(produceData)))

            # create links
            if (produceSMTFolder = check_and_update_folder({:project_id => project_id, :title => "SMT", :user_id => admin_id, :dmsf_folder_id => produceFolder.id}))

                check_and_update_link({:target_type => "DmsfFolder", :name => "pick_and_place", :target_project_id => project_id, :target_id => papFolder.id, :project_id => project_id, :dmsf_folder_id => produceSMTFolder.id})
                check_and_update_link({:target_type => "DmsfFolder", :name => "smt_gerbers", :target_project_id => project_id, :target_id => smtFolder.id, :project_id => project_id, :dmsf_folder_id => produceSMTFolder.id})

            end

            check_and_update_link({:target_type => "DmsfFolder", :name => "BIN", :target_project_id => project_id, :target_id => binFolder.id, :project_id => project_id, :dmsf_folder_id => produceFolder.id})
            check_and_update_link({:target_type => "DmsfFolder", :name => "BOM", :target_project_id => project_id, :target_id => bomFolder.id, :project_id => project_id, :dmsf_folder_id => produceFolder.id})
            check_and_update_link({:target_type => "DmsfFolder", :name => "release", :target_project_id => project_id, :target_id => releaseFolder.id, :project_id => project_id, :dmsf_folder_id => produceFolder.id})

    end
end