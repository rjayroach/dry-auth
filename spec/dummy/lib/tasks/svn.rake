
namespace :custom do
  namespace :svn do

    desc "Add new files to subversion"
    task :add do
      system "svn status | grep '^?' | sed -e 's/? *//' | sed -e 's/ / /g' | xargs svn add"
    end


    desc "Create the Subversion project"
    task :create => ['custom:svn:clean'] do
      # if this is an engine it will have a spec/dummy directory, otherwise it is a standard app
      working_dir = FileUtils.pwd.split('/').last.eql?('dummy') ? "../.." : FileUtils.pwd
      tmp_dir = "/tmp/dry_auth"
      FileUtils.rm_rf "#{tmp_dir}"
      FileUtils.mkdir_p "#{tmp_dir}/trunk"

      Dir.chdir(working_dir) do
        FileUtils.rm_rf "coverage"
        FileUtils.rm_rf "tmp"
        # See: http://superuser.com/questions/62141/linux-how-to-move-all-files-from-current-directory-to-upper-directory
        system "cp -a * .[^.]* #{tmp_dir}/trunk"
      end
      Dir.chdir(tmp_dir) do
        FileUtils.mkdir "tags"
        FileUtils.mkdir "branches"
        system "svn import . http://svn.maxcole.com/dry_auth -m 'New App: dry_auth' --username rr1969"
      end
      FileUtils.rm_rf "#{tmp_dir}"
    end



    #desc "Clean Project before creating Subversion project for Rails Engine"
    task :clean => [ 'assets:clean' ] do
      system "rm -rf log/*"
      system "rm -rf tmp/*"
      system "rm -rf db/migrate/*"
      system "rm -rf db/*.sqlite3"
      #system 'mv config/database.yml config/database_example.yml'
    end


    #desc "Configure Subversion for Rails Engine (run after Subversion project is created"
    task :setup do
      #system 'svn propset svn:ignore database.yml config/'
      system 'svn propset svn:ignore "*" log/'
      system 'svn propset svn:ignore "*" tmp/'
      system 'svn propset svn:ignore "*" db/migrate/'
      system 'svn propset svn:ignore "*.sqlite3" db/'
    end



  end # namespace :svn
end # namespace :custom


