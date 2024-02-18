<template>
  <div class="py-4 container-fluid">
    <div class="row">
      <div class="col-12">
        <loans-table />
      </div>
    </div>
    <div class="row">
      <div class="col-12">
        <projects-table />
      </div>
    </div>
  </div>
</template>

<script>
import LoansTable from "./components/LoansTable.vue";
import ProjectsTable from "./components/ProjectsTable.vue";

export default {
  name: "LoansPage",
  components: {
    LoansTable,
    ProjectsTable,
  },
};
</script>
